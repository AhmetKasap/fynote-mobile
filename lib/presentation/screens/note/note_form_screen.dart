import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Klasör Seç',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(modalContext),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            // No folder option
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedFolder = null;
                  });
                  Navigator.pop(modalContext);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.note_outlined,
                          size: 20,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Klasörsüz',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (_selectedFolder == null)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (folders.isNotEmpty) ...[
              Divider(height: 1, color: Theme.of(context).dividerColor),
              const SizedBox(height: 8),
            ],
            // Folders list
            if (folders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_off_outlined,
                        size: 48,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Henüz klasör yok',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...folders.map((folder) {
                final isSelected = _selectedFolder?.id == folder.id;
                Color folderColor = Theme.of(context).colorScheme.primary;
                if (folder.color != null) {
                  try {
                    folderColor = Color(
                      int.parse(folder.color!.replaceFirst('#', '0xff')),
                    );
                  } catch (e) {
                    // Keep default color
                  }
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFolder = folder;
                      });
                      Navigator.pop(modalContext);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: folderColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: folder.icon != null
                                  ? SvgPicture.network(
                                      folder.icon!.fileUrl,
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        folderColor,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : Icon(
                                      Icons.folder,
                                      color: folderColor,
                                      size: 20,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              folder.name,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
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

  Widget _buildToolbarButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 19,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  void _showHeaderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Metin Stili',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            _buildHeaderOption(
              context: context,
              title: 'Normal',
              style: const TextStyle(fontSize: 16),
              onTap: () {
                _quillController.formatSelection(Attribute.header);
                Navigator.pop(context);
              },
            ),
            _buildHeaderOption(
              context: context,
              title: 'Başlık 1',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              onTap: () {
                _quillController.formatSelection(Attribute.h1);
                Navigator.pop(context);
              },
            ),
            _buildHeaderOption(
              context: context,
              title: 'Başlık 2',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              onTap: () {
                _quillController.formatSelection(Attribute.h2);
                Navigator.pop(context);
              },
            ),
            _buildHeaderOption(
              context: context,
              title: 'Başlık 3',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              onTap: () {
                _quillController.formatSelection(Attribute.h3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderOption({
    required BuildContext context,
    required String title,
    required TextStyle style,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: style.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    final colors = [
      {'color': const Color(0xFF000000), 'hex': '#000000', 'name': 'Siyah'},
      {'color': const Color(0xFFEF4444), 'hex': '#EF4444', 'name': 'Kırmızı'},
      {'color': const Color(0xFF3B82F6), 'hex': '#3B82F6', 'name': 'Mavi'},
      {'color': const Color(0xFF10B981), 'hex': '#10B981', 'name': 'Yeşil'},
      {'color': const Color(0xFFF59E0B), 'hex': '#F59E0B', 'name': 'Turuncu'},
      {'color': const Color(0xFF8B5CF6), 'hex': '#8B5CF6', 'name': 'Mor'},
      {'color': const Color(0xFF64748B), 'hex': '#64748B', 'name': 'Gri'},
      {'color': const Color(0xFFEC4899), 'hex': '#EC4899', 'name': 'Pembe'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Metin Rengi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(modalContext),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: colors.map((colorData) {
                final color = colorData['color'] as Color;
                final hex = colorData['hex'] as String;
                final name = colorData['name'] as String;
                return InkWell(
                  onTap: () {
                    _quillController.formatSelection(
                      Attribute.fromKeyValue('color', hex),
                    );
                    Navigator.pop(modalContext);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
            // Compact header with icon, title and folder
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Icon and folder row
                  Row(
                    children: [
                      // Compact Icon Picker
                      Tooltip(
                        message: 'Icon seç',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _pickIcon,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: _selectedIcon != null
                                    ? SvgPicture.network(
                                        _selectedIcon!.fileUrl,
                                        width: 18,
                                        height: 18,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).colorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      )
                                    : Icon(
                                        Icons.tag_rounded,
                                        size: 18,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Compact Folder Picker
                      Tooltip(
                        message: 'Klasör seç',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showFolderPicker,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedFolder != null
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1)
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _selectedFolder != null
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.folder_outlined,
                                    size: 16,
                                    color: _selectedFolder != null
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 6),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 120,
                                    ),
                                    child: Text(
                                      _selectedFolder?.name ?? 'Klasör',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedFolder != null
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Compact Title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Başlık ekle...',
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 4,
                      ),
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Başlık gerekli';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            // Ultra Minimal Toolbar
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.format_bold,
                    tooltip: 'Kalın',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.bold),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.format_italic,
                    tooltip: 'İtalik',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.italic),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.format_underlined,
                    tooltip: 'Altı çizili',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.underline),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.title_outlined,
                    tooltip: 'Başlık',
                    onPressed: () => _showHeaderPicker(),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.format_list_bulleted,
                    tooltip: 'Liste',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.ul),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.format_list_numbered,
                    tooltip: 'Numaralı liste',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.ol),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.check_box_outlined,
                    tooltip: 'Yapılacaklar',
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.unchecked),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                  _buildToolbarButton(
                    context: context,
                    icon: Icons.palette_outlined,
                    tooltip: 'Renk',
                    onPressed: () => _showColorPicker(),
                  ),
                ],
              ),
            ),
            // Quill Editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: QuillEditor.basic(controller: _quillController),
              ),
            ),
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
