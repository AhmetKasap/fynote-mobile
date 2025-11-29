import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/program.dart';
import 'program_status_badge.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  const ProgramCard({super.key, required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'tr_TR');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve durum
              Row(
                children: [
                  Expanded(
                    child: Text(
                      program.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ProgramStatusBadge(status: program.status),
                ],
              ),

              const SizedBox(height: 12),

              // İçerik (sadece tamamlandıysa)
              if (program.isCompleted && program.contentJson != null) ...[
                if (program.contentJson!.summary != null)
                  Text(
                    program.contentJson!.summary!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (program.contentJson!.totalActivities != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${program.contentJson!.totalActivities} aktivite',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    if (program.contentJson!.estimatedDuration != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            program.contentJson!.estimatedDuration!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],

              // İşleniyorsa
              if (program.isProcessing) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Programınız yapay zeka ile hazırlanıyor...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Başarısızsa
              if (program.isFailed) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          program.errorMessage ?? 'Bir hata oluştu',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Tarih
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(program.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
