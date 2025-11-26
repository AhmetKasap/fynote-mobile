import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/folder_provider.dart';
import '../../providers/note_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/folder_card.dart';
import '../../widgets/note_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes to update FAB label
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // Load data
    Future.microtask(() {
      ref.read(folderProvider.notifier).getFolders();
      ref.read(noteProvider.notifier).getNotes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final themeState = ref.watch(themeProvider);
    final isDark =
        themeState.themeMode == ThemeMode.dark ||
        (themeState.themeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    final folderState = ref.watch(folderProvider);
    final noteState = ref.watch(noteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.note_alt_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text('FyNote'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Klasörler', icon: Icon(Icons.folder_outlined)),
            Tab(text: 'Notlar', icon: Icon(Icons.note_outlined)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme(!isDark);
            },
            tooltip: isDark ? 'Açık Mod' : 'Karanlık Mod',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                user?.initials ?? '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              context.push(AppRouter.profile);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Folders Tab
          _buildFoldersTab(folderState),
          // Notes Tab
          _buildNotesTab(noteState),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            // Create Folder
            context.push(AppRouter.createFolder).then((value) {
              if (value == true) {
                ref.read(folderProvider.notifier).getFolders();
              }
            });
          } else {
            // Create Note
            context.push(AppRouter.createNote).then((value) {
              if (value == true) {
                ref.read(noteProvider.notifier).getNotes();
              }
            });
          }
        },
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'Yeni Klasör' : 'Yeni Not'),
      ),
    );
  }

  Widget _buildFoldersTab(FolderState state) {
    if (state.isLoading && state.folders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.folders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(folderProvider.notifier).getFolders(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (state.folders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz klasör yok',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Notlarınızı organize etmek için klasör oluşturun',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(folderProvider.notifier).getFolders();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.folders.length,
        itemBuilder: (context, index) {
          final folder = state.folders[index];
          return FolderCard(
            folder: folder,
            onTap: () {
              // Navigate to folder notes
              setState(() {
                _selectedFolderId = folder.id;
                _tabController.animateTo(1);
              });
              ref.read(noteProvider.notifier).getNotes(folderId: folder.id);
            },
            onEdit: () {
              context.push('${AppRouter.editFolder}/${folder.id}').then((
                value,
              ) {
                if (value == true) {
                  ref.read(folderProvider.notifier).getFolders();
                }
              });
            },
            onDelete: () {
              _showDeleteFolderDialog(folder.id, folder.name);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotesTab(NoteState state) {
    if (state.isLoading && state.notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(noteProvider.notifier).getNotes(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Folder filter chip
        if (_selectedFolderId != null)
          Container(
            padding: const EdgeInsets.all(8),
            child: Chip(
              label: const Text('Klasördeki Notlar'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() {
                  _selectedFolderId = null;
                });
                ref.read(noteProvider.notifier).getNotes();
              },
            ),
          ),
        // Notes list
        Expanded(
          child: state.notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.note_outlined,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Henüz not yok',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Düşüncelerinizi not almaya başlayın',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(noteProvider.notifier)
                        .getNotes(folderId: _selectedFolderId);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NoteCard(
                          note: note,
                          onTap: () {
                            context
                                .push('${AppRouter.noteDetail}/${note.id}')
                                .then((value) {
                                  if (value == true) {
                                    ref
                                        .read(noteProvider.notifier)
                                        .getNotes(folderId: _selectedFolderId);
                                  }
                                });
                          },
                          onEdit: () {
                            context
                                .push('${AppRouter.editNote}/${note.id}')
                                .then((value) {
                                  if (value == true) {
                                    ref
                                        .read(noteProvider.notifier)
                                        .getNotes(folderId: _selectedFolderId);
                                  }
                                });
                          },
                          onDelete: () {
                            _showDeleteNoteDialog(note.id, note.title);
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  void _showDeleteFolderDialog(String folderId, String folderName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasörü Sil'),
        content: Text(
          '"$folderName" klasörünü ve içindeki tüm notları silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(folderProvider.notifier)
                  .deleteFolder(folderId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Klasör başarıyla silindi')),
                );
              }
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteNoteDialog(String noteId, String noteTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Sil'),
        content: Text('"$noteTitle" notunu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(noteProvider.notifier)
                  .deleteNote(noteId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not başarıyla silindi')),
                );
              }
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
