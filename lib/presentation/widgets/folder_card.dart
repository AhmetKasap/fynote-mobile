import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/folder.dart';
import '../../core/theme/app_colors.dart';

class FolderCard extends StatelessWidget {
  final FolderEntity folder;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
  });

  Color _getFolderColor() {
    if (folder.color != null && folder.color!.isNotEmpty) {
      try {
        return Color(int.parse(folder.color!.replaceFirst('#', '0xff')));
      } catch (e) {
        return AppColors.primary;
      }
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final folderColor = _getFolderColor();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: folderColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: folder.icon != null
                          ? SvgPicture.network(
                              folder.icon!.fileUrl,
                              width: 28,
                              height: 28,
                              colorFilter: ColorFilter.mode(
                                folderColor,
                                BlendMode.srcIn,
                              ),
                            )
                          : Icon(Icons.folder, size: 28, color: folderColor),
                    ),
                  ),
                  const Spacer(),
                  // Actions
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Düzenle'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Sil',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Folder Name
              Text(
                folder.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Created Date
              if (folder.createdAt != null)
                Text(
                  _formatDate(folder.createdAt!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
