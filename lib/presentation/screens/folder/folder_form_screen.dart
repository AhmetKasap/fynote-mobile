import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/icon.dart';
import '../../providers/folder_provider.dart';
import '../../widgets/icon_picker_dialog.dart';

class FolderFormScreen extends ConsumerStatefulWidget {
  final String? folderId;

  const FolderFormScreen({super.key, this.folderId});

  @override
  ConsumerState<FolderFormScreen> createState() => _FolderFormScreenState();
}

class _FolderFormScreenState extends ConsumerState<FolderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  IconEntity? _selectedIcon;
  Color? _selectedColor;
  bool _isLoading = false;

  // Predefined colors
  final List<Color> _colors = [
    AppColors.primary,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.red,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.folderId != null) {
      // Load folder after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadFolder();
      });
    }
  }

  Future<void> _loadFolder() async {
    await ref.read(folderProvider.notifier).getFolder(widget.folderId!);

    if (mounted) {
      final folderState = ref.read(folderProvider);
      if (folderState.selectedFolder != null) {
        final folder = folderState.selectedFolder!;
        setState(() {
          _nameController.text = folder.name;
          _selectedIcon = folder.icon;
          if (folder.color != null) {
            try {
              _selectedColor = Color(
                int.parse(folder.color!.replaceFirst('#', '0xff')),
              );
            } catch (e) {
              _selectedColor = null;
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    // Clear selected folder when leaving screen
    if (widget.folderId != null) {
      ref.read(folderProvider.notifier).clearSelectedFolder();
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

  String? _colorToHex(Color? color) {
    if (color == null) return null;
    return '#${color.value.toRadixString(16).substring(2, 8)}';
  }

  Future<void> _saveFolder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    bool success;
    if (widget.folderId != null) {
      // Update
      success = await ref
          .read(folderProvider.notifier)
          .updateFolder(
            id: widget.folderId!,
            name: _nameController.text.trim(),
            iconId: _selectedIcon?.id,
            color: _colorToHex(_selectedColor),
          );
    } else {
      // Create
      success = await ref
          .read(folderProvider.notifier)
          .createFolder(
            name: _nameController.text.trim(),
            iconId: _selectedIcon?.id,
            color: _colorToHex(_selectedColor),
          );
    }

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      final error = ref.read(folderProvider).error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.folderId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Klasörü Düzenle' : 'Yeni Klasör')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Picker
              Text(
                'İkon',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickIcon,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (_selectedColor ?? AppColors.primary).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: _selectedIcon != null
                        ? SvgPicture.network(
                            _selectedIcon!.fileUrl,
                            width: 40,
                            height: 40,
                            colorFilter: ColorFilter.mode(
                              _selectedColor ?? AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: _selectedColor ?? AppColors.primary,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Folder Name
              Text(
                'Klasör Adı',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: İş Notları',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Klasör adı gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Color Picker
              Text(
                'Renk',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveFolder,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Kaydet' : 'Oluştur'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
