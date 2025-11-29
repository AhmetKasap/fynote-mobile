import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../providers/note_provider.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  QuillController? _controller;
  bool _hasLoadedNote = false;

  @override
  void initState() {
    super.initState();
    // Load note after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNote();
    });
  }

  Future<void> _loadNote() async {
    await ref.read(noteProvider.notifier).getNote(widget.noteId);

    if (mounted) {
      final noteState = ref.read(noteProvider);
      if (noteState.selectedNote != null) {
        final note = noteState.selectedNote!;
        try {
          // Parse JSON content - contentJson should have 'ops' key
          final List<dynamic> deltaOps =
              (note.contentJson['ops'] as List<dynamic>?) ?? [];

          final delta = Delta.fromJson(deltaOps);
          final doc = Document.fromDelta(delta);

          setState(() {
            _controller = QuillController(
              document: doc,
              selection: const TextSelection.collapsed(offset: 0),
            );
            _hasLoadedNote = true;
          });
        } catch (e) {
          // Fallback to plain text if JSON parsing fails
          final controller = QuillController.basic();
          controller.document.insert(0, note.contentText);

          setState(() {
            _controller = controller;
            _hasLoadedNote = true;
          });
        }
      } else {
        setState(() {
          _hasLoadedNote = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Clear selected note when leaving screen
    ref.read(noteProvider.notifier).clearSelectedNote();
    super.dispose();
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Sil'),
        content: const Text('Bu notu silmek istediğinize emin misiniz?'),
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
                  .deleteNote(widget.noteId);
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

  @override
  Widget build(BuildContext context) {
    final noteState = ref.watch(noteProvider);
    final note = noteState.selectedNote;

    // Show loading while fetching or initializing controller
    if (!_hasLoadedNote || (note != null && _controller == null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show error if note not found
    if (note == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Bulunamadı')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.note_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Not bulunamadı'),
              if (noteState.error != null) ...[
                const SizedBox(height: 8),
                Text(
                  noteState.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Ensure controller is ready
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (note.icon != null) ...[
              SvgPicture.network(
                note.icon!.fileUrl,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(note.title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteNote),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Metadata
            Row(
              children: [
                if (note.createdAt != null) ...[
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.createdAt!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
            const Divider(height: 32),
            // Content (Read-only Quill Editor)
            QuillEditor.basic(controller: _controller!),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Dün ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
