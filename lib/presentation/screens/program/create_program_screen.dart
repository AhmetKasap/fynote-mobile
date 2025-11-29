import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/program_provider.dart';
import '../../router/app_router.dart';

class CreateProgramScreen extends ConsumerStatefulWidget {
  const CreateProgramScreen({super.key});

  @override
  ConsumerState<CreateProgramScreen> createState() =>
      _CreateProgramScreenState();
}

class _CreateProgramScreenState extends ConsumerState<CreateProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();
  final _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _audioRecorder.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    // Mikrofon izni kontrol et
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mikrofon izni gerekli'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Geçici dizin
      final tempDir = await getTemporaryDirectory();
      _audioPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      // Kayıt başlat
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: _audioPath!,
      );

      setState(() {
        _isRecording = true;
        _recordDuration = Duration.zero;
      });

      // Süre sayacı - Timer.periodic kullanarak
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isRecording && mounted) {
          setState(() {
            _recordDuration = Duration(seconds: timer.tick);
          });
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başlatılamadı: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _recordingTimer?.cancel();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt durdurulamadı: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deleteRecording() {
    if (_audioPath != null) {
      try {
        final file = File(_audioPath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        // Sessizce hata yok say
      }
    }
    setState(() {
      _audioPath = null;
      _recordDuration = Duration.zero;
    });
  }

  Future<void> _createProgramFromText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen program açıklaması girin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final programId = await ref
        .read(programProvider.notifier)
        .createProgramFromText(text);

    if (programId != null && mounted) {
      context.go('${AppRouter.programDetail}/$programId');
    }
  }

  Future<void> _createProgramFromAudio() async {
    if (_audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen önce ses kaydı yapın'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final audioFile = File(_audioPath!);
    if (!audioFile.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ses dosyası bulunamadı'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final programId = await ref
        .read(programProvider.notifier)
        .createProgramFromAudio(audioFile);

    if (programId != null && mounted) {
      // Ses dosyasını temizle
      try {
        await audioFile.delete();
      } catch (_) {}

      context.go('${AppRouter.programDetail}/$programId');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programProvider);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Program Oluştur'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.text_fields), text: 'Metin'),
            Tab(icon: Icon(Icons.mic), text: 'Ses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTextTab(state, theme), _buildAudioTab(state, theme)],
      ),
    );
  }

  Widget _buildTextTab(ProgramState state, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nasıl Kullanılır?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Günlük programınızı yazın. Örneğin:\n\n'
                    '"Sabah 7\'de kalk, spor yap, kahvaltı et, '
                    '9\'da işe başla, öğlen yemeği, akşam ders çalış"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Program açıklamanızı buraya yazın...',
              border: OutlineInputBorder(),
            ),
            enabled: !state.isCreating,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: state.isCreating ? null : _createProgramFromText,
            icon: state.isCreating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(
              state.isCreating ? 'Oluşturuluyor...' : 'Program Oluştur',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTab(ProgramState state, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nasıl Kullanılır?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mikrofon butonuna basın ve günlük programınızı sesli olarak anlatın. '
                    'Yapay zeka ses kaydınızı metne çevirecek ve size uygun bir program oluşturacak.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                // Kayıt butonu
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? Colors.red
                          : theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_isRecording
                                      ? Colors.red
                                      : theme.colorScheme.primary)
                                  .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording
                      ? 'Kayıt Ediliyor...'
                      : (_audioPath != null
                            ? 'Kayıt Tamamlandı'
                            : 'Mikrofona Dokun'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isRecording) ...[
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(_recordDuration),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (_audioPath != null && !_isRecording) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Süre: ${_formatDuration(_recordDuration)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (_audioPath != null && !_isRecording) ...[
            FilledButton.icon(
              onPressed: state.isCreating ? null : _createProgramFromAudio,
              icon: state.isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                state.isCreating ? 'Oluşturuluyor...' : 'Program Oluştur',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: state.isCreating ? null : _deleteRecording,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Kaydı Sil'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
