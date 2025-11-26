import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/icon.dart';
import '../../core/theme/app_colors.dart';
import '../providers/icon_provider.dart';

class IconPickerDialog extends ConsumerStatefulWidget {
  final IconEntity? selectedIcon;

  const IconPickerDialog({super.key, this.selectedIcon});

  @override
  ConsumerState<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends ConsumerState<IconPickerDialog> {
  IconEntity? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
    // Load icons when dialog opens
    Future.microtask(() => ref.read(iconProvider.notifier).getIcons());
  }

  @override
  Widget build(BuildContext context) {
    final iconState = ref.watch(iconProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'İkon Seç',
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
            // Content
            if (iconState.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (iconState.error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(iconState.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(iconProvider.notifier).getIcons(),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              )
            else if (iconState.icons.isEmpty)
              const Expanded(child: Center(child: Text('İkon bulunamadı')))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: iconState.icons.length,
                  itemBuilder: (context, index) {
                    final icon = iconState.icons[index];
                    final isSelected = _selectedIcon?.id == icon.id;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surface,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SvgPicture.network(
                            icon.fileUrl,
                            width: 32,
                            height: 32,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _selectedIcon),
                    child: const Text('Seç'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the dialog
Future<IconEntity?> showIconPickerDialog(
  BuildContext context, {
  IconEntity? selectedIcon,
}) async {
  return await showDialog<IconEntity>(
    context: context,
    builder: (context) => IconPickerDialog(selectedIcon: selectedIcon),
  );
}
