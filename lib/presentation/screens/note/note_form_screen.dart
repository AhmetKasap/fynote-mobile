import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/icon.dart';
import '../../../domain/entities/folder.dart';
import '../../providers/note_provider.dart';
import '../../providers/folder_provider.dart';
import '../../widgets/icon_picker_dialog.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteFormScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late QuillController _quillController;

  IconEntity? _selectedIcon;
  FolderEntity? _selectedFolder;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with empty document
    _quillController = QuillController.basic();

    // Load folders and note after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(folderProvider.notifier).getFolders();

      if (widget.noteId != null) {
        _loadNote();
      } else {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  Future<void> _loadNote() async {
    await ref.read(noteProvider.notifier).getNote(widget.noteId!);

    if (mounted) {
      final noteState = ref.read(noteProvider);
      if (noteState.selectedNote != null) {
        final note = noteState.selectedNote!;

        // Load folder if exists
        FolderEntity? folder;
        if (note.folderId != null) {
          final folders = ref.read(folderProvider).folders;
          try {
            folder = folders.firstWhere((f) => f.id == note.folderId);
          } catch (e) {
            folder = null;
          }
        }

        // Load content into Quill
        QuillController newController;
        try {
          // contentJson should have 'ops' key
          final List<dynamic> deltaOps =
              (note.contentJson['ops'] as List<dynamic>?) ?? [];

          final delta = Delta.fromJson(deltaOps);
          final doc = Document.fromDelta(delta);
          newController = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (e) {
          // Fallback to plain text
          newController = QuillController.basic();
          newController.document.insert(0, note.contentText);
        }

        setState(() {
          _titleController.text = note.title;
          _selectedIcon = note.icon;
          _selectedFolder = folder;
          _quillController.dispose();
          _quillController = newController;
          _isInitialized = true;
        });
      } else {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    // Clear selected note when leaving screen
    if (widget.noteId != null) {
      ref.read(noteProvider.notifier).clearSelectedNote();
    }
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final icon = await showIconPickerDialog(
      context,
      selectedIcon: _selectedIcon,
    );
    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  void _showFolderPicker() {
    final folders = ref.read(folderProvider).folders;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Klasör Seç',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            // No folder option
            ListTile(
              leading: const Icon(Icons.note_outlined),
              title: const Text('Klasörsüz'),
              trailing: _selectedFolder == null
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedFolder = null;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Folders list
            if (folders.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Henüz klasör yok')),
              )
            else
              ...folders.map((folder) {
                final isSelected = _selectedFolder?.id == folder.id;
                Color folderColor = AppColors.primary;
                if (folder.color != null) {
                  try {
                    folderColor = Color(
                      int.parse(folder.color!.replaceFirst('#', '0xff')),
                    );
                  } catch (e) {
                    // Keep default color
                  }
                }

                return ListTile(
                  leading: folder.icon != null
                      ? SvgPicture.network(
                          folder.icon!.fileUrl,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            folderColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(Icons.folder, color: folderColor),
                  title: Text(folder.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFolder = folder;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  String _getPlainTextFromDocument() {
    return _quillController.document.toPlainText();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final plainText = _getPlainTextFromDocument();
    if (plainText.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('İçerik boş olamaz')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Convert Quill document to JSON (wrap in 'ops' key)
    final contentJson = {'ops': _quillController.document.toDelta().toJson()};

    bool success;
    if (widget.noteId != null) {
      // Update
      success = await ref
          .read(noteProvider.notifier)
          .updateNote(
            id: widget.noteId!,
            title: _titleController.text.trim(),
            contentText: plainText,
            contentJson: contentJson,
            folderId: _selectedFolder?.id,
            iconId: _selectedIcon?.id,
          );
    } else {
      // Create
      success = await ref
          .read(noteProvider.notifier)
          .createNote(
            title: _titleController.text.trim(),
            contentText: plainText,
            contentJson: contentJson,
            folderId: _selectedFolder?.id,
            iconId: _selectedIcon?.id,
          );
    }

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      final error = ref.read(noteProvider).error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.noteId != null;

    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Notu Düzenle' : 'Yeni Not'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveNote,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Top bar with icon and folder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  // Icon Picker
                  InkWell(
                    onTap: _pickIcon,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: _selectedIcon != null
                            ? SvgPicture.network(
                                _selectedIcon!.fileUrl,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 24,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Folder Picker
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFolderPicker,
                      icon: const Icon(Icons.folder_outlined, size: 20),
                      label: Text(
                        _selectedFolder?.name ?? 'Klasör Seç',
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Başlık',
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
            ),
            const Divider(height: 1),
            // Quill Toolbar
            QuillSimpleToolbar(
              controller: _quillController,
              config: const QuillSimpleToolbarConfig(
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showListNumbers: true,
                showListBullets: true,
                showListCheck: true,
                showCodeBlock: false,
                showInlineCode: false,
                showLink: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: false,
                showAlignmentButtons: false,
                showHeaderStyle: true,
              ),
            ),
            const Divider(height: 1),
            // Quill Editor
            Expanded(child: QuillEditor.basic(controller: _quillController)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveNote,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? 'Kaydet' : 'Oluştur'),
          ),
        ),
      ),
    );
  }
}
