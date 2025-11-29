import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/program.dart';
import 'usecase_providers.dart';

/// Program State
class ProgramState {
  final bool isLoading;
  final bool isCreating;
  final List<Program> programs;
  final Program? selectedProgram;
  final String? error;
  final String? successMessage;

  const ProgramState({
    this.isLoading = false,
    this.isCreating = false,
    this.programs = const [],
    this.selectedProgram,
    this.error,
    this.successMessage,
  });

  ProgramState copyWith({
    bool? isLoading,
    bool? isCreating,
    List<Program>? programs,
    Program? selectedProgram,
    String? error,
    String? successMessage,
  }) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      programs: programs ?? this.programs,
      selectedProgram: selectedProgram ?? this.selectedProgram,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Program Notifier
class ProgramNotifier extends StateNotifier<ProgramState> {
  final Ref ref;
  Timer? _pollingTimer;
  String? _pollingProgramId;

  ProgramNotifier(this.ref) : super(const ProgramState());

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  /// Tüm programları getir
  Future<void> getPrograms() async {
    state = state.copyWith(isLoading: true, error: null);

    final getProgramsUseCase = ref.read(getProgramsUseCaseProvider);
    final result = await getProgramsUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (programs) {
        state = state.copyWith(isLoading: false, programs: programs);
      },
    );
  }

  /// ID'ye göre program getir
  Future<void> getProgramById(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final getProgramByIdUseCase = ref.read(getProgramByIdUseCaseProvider);
    final result = await getProgramByIdUseCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (program) {
        state = state.copyWith(isLoading: false, selectedProgram: program);

        // Program hala processing'se polling başlat
        if (program.isProcessing) {
          _startPolling(id);
        }
      },
    );
  }

  /// Metinden program oluştur
  Future<String?> createProgramFromText(String text) async {
    state = state.copyWith(isCreating: true, error: null);

    final createProgramFromTextUseCase = ref.read(
      createProgramFromTextUseCaseProvider,
    );
    final result = await createProgramFromTextUseCase(text);

    return result.fold(
      (failure) {
        state = state.copyWith(isCreating: false, error: failure.message);
        return null;
      },
      (response) {
        state = state.copyWith(
          isCreating: false,
          successMessage: response.message,
        );

        // Programları yeniden yükle
        getPrograms();

        // Polling başlat
        _startPolling(response.id);

        return response.id;
      },
    );
  }

  /// Ses dosyasından program oluştur
  Future<String?> createProgramFromAudio(File audioFile) async {
    state = state.copyWith(isCreating: true, error: null);

    final createProgramFromAudioUseCase = ref.read(
      createProgramFromAudioUseCaseProvider,
    );
    final result = await createProgramFromAudioUseCase(audioFile);

    return result.fold(
      (failure) {
        state = state.copyWith(isCreating: false, error: failure.message);
        return null;
      },
      (response) {
        state = state.copyWith(
          isCreating: false,
          successMessage: response.message,
        );

        // Programları yeniden yükle
        getPrograms();

        // Polling başlat
        _startPolling(response.id);

        return response.id;
      },
    );
  }

  /// Program sil
  Future<bool> deleteProgram(String id) async {
    final deleteProgramUseCase = ref.read(deleteProgramUseCaseProvider);
    final result = await deleteProgramUseCase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          programs: state.programs.where((p) => p.id != id).toList(),
          successMessage: 'Program başarıyla silindi',
        );
        return true;
      },
    );
  }

  /// Polling başlat (program durumunu kontrol et)
  void _startPolling(String programId) {
    _pollingProgramId = programId;
    _stopPolling();

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_pollingProgramId == null) return;

      final getProgramByIdUseCase = ref.read(getProgramByIdUseCaseProvider);
      final result = await getProgramByIdUseCase(_pollingProgramId!);

      result.fold(
        (failure) {
          _stopPolling();
        },
        (program) {
          // Program listesini güncelle
          final updatedPrograms = state.programs.map((p) {
            return p.id == program.id ? program : p;
          }).toList();

          // Seçili programı güncelle (eğer aynıysa)
          final updatedSelectedProgram = state.selectedProgram?.id == program.id
              ? program
              : state.selectedProgram;

          state = state.copyWith(
            programs: updatedPrograms,
            selectedProgram: updatedSelectedProgram,
          );

          // Program tamamlandı veya başarısız olduysa polling'i durdur
          if (!program.isProcessing) {
            if (program.isCompleted) {
              state = state.copyWith(
                successMessage: 'Programınız başarıyla oluşturuldu!',
              );
            } else if (program.isFailed) {
              state = state.copyWith(
                error: program.errorMessage ?? 'Program oluşturulamadı',
              );
            }
            _stopPolling();
          }
        },
      );
    });
  }

  /// Polling'i durdur
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _pollingProgramId = null;
  }

  /// Hata mesajını temizle
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Başarı mesajını temizle
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  /// Seçili programı temizle
  void clearSelectedProgram() {
    state = state.copyWith(selectedProgram: null);
  }
}

/// Provider
final programProvider = StateNotifierProvider<ProgramNotifier, ProgramState>((
  ref,
) {
  return ProgramNotifier(ref);
});
