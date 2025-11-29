import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/program_provider.dart';
import '../../widgets/program/program_status_badge.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  ConsumerState<ProgramDetailScreen> createState() =>
      _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(programProvider.notifier).getProgramById(widget.programId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programProvider);
    final program = state.selectedProgram;
    final theme = Theme.of(context);

    // Listen to errors and success messages
    ref.listen<ProgramState>(programProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
        ref.read(programProvider.notifier).clearError();
      }

      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(programProvider.notifier).clearSuccessMessage();
      }
    });

    if (state.isLoading || program == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Program Detayı')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, program.id),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(programProvider.notifier)
              .getProgramById(widget.programId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ProgramStatusBadge(status: program.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Oluşturulma: ${DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(program.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 24),

              // İşleniyorsa
              if (program.isProcessing) ...[
                Card(
                  color: Colors.orange.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Programınız hazırlanıyor',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Yapay zeka programınızı analiz ediyor ve size özel bir program oluşturuyor. Bu işlem birkaç dakika sürebilir.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Başarısızsa
              if (program.isFailed) ...[
                Card(
                  color: Colors.red.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Program oluşturulamadı',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                program.errorMessage ??
                                    'Bir hata oluştu. Lütfen tekrar deneyin.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Tamamlandıysa
              if (program.isCompleted && program.contentJson != null) ...[
                // Özet
                if (program.contentJson!.summary != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Özet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            program.contentJson!.summary!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // İstatistikler
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_note,
                                color: theme.colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${program.contentJson!.totalActivities ?? 0}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Aktivite',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (program.contentJson!.estimatedDuration != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: theme.colorScheme.secondary,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  program.contentJson!.estimatedDuration!,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.secondary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Süre',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Etiketler
                if (program.contentJson!.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: program.contentJson!.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Aktiviteler
                Text(
                  'Günlük Aktiviteler',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...program.contentJson!.dailyRoutine.map((activity) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(
                          activity.category,
                        ).withOpacity(0.2),
                        child: Icon(
                          _getCategoryIcon(activity.category),
                          color: _getCategoryColor(activity.category),
                        ),
                      ),
                      title: Text(
                        activity.activity,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('${activity.time} - ${activity.duration}'),
                            ],
                          ),
                          if (activity.notes != null &&
                              activity.notes!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              activity.notes!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: _getPriorityBadge(activity.priority),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.purple;
      case 'health':
        return Colors.green;
      case 'social':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'health':
        return Icons.fitness_center;
      case 'social':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  Widget _getPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String programId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programı Sil'),
        content: const Text('Bu programı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(programProvider.notifier)
                  .deleteProgram(programId);
              if (success && mounted) {
                context.pop(true);
              }
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
