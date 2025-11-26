import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note.dart';
import 'usecase_providers.dart';

/// Note State
class NoteState {
  final bool isLoading;
  final List<NoteEntity> notes;
  final NoteEntity? selectedNote;
  final String? currentFolderId;
  final String? error;
  final String? successMessage;

  const NoteState({
    this.isLoading = false,
    this.notes = const [],
    this.selectedNote,
    this.currentFolderId,
    this.error,
    this.successMessage,
  });

  NoteState copyWith({
    bool? isLoading,
    List<NoteEntity>? notes,
    Object? selectedNote = const _Undefined(),
    String? currentFolderId,
    String? error,
    String? successMessage,
  }) {
    return NoteState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      selectedNote: selectedNote == const _Undefined()
          ? this.selectedNote
          : selectedNote as NoteEntity?,
      currentFolderId: currentFolderId ?? this.currentFolderId,
      error: error,
      successMessage: successMessage,
    );
  }
}

class _Undefined {
  const _Undefined();
}

/// Note State Notifier
class NoteNotifier extends StateNotifier<NoteState> {
  final Ref ref;

  NoteNotifier(this.ref) : super(const NoteState());

  /// Get all notes (optionally filtered by folder)
  Future<void> getNotes({String? folderId}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentFolderId: folderId,
    );

    final getNotesUseCase = ref.read(getNotesUseCaseProvider);
    final result = await getNotesUseCase(folderId: folderId);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (notes) {
        state = state.copyWith(isLoading: false, notes: notes);
      },
    );
  }

  /// Get note by id
  Future<void> getNote(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final getNoteUseCase = ref.read(getNoteUseCaseProvider);
    final result = await getNoteUseCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (note) {
        state = state.copyWith(isLoading: false, selectedNote: note);
      },
    );
  }

  /// Create note
  Future<bool> createNote({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final createNoteUseCase = ref.read(createNoteUseCaseProvider);
    final result = await createNoteUseCase(
      title: title,
      contentText: contentText,
      contentJson: contentJson,
      folderId: folderId,
      iconId: iconId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (note) {
        final updatedNotes = [...state.notes, note];
        state = state.copyWith(
          isLoading: false,
          notes: updatedNotes,
          successMessage: 'Not başarıyla oluşturuldu',
        );
        return true;
      },
    );
  }

  /// Update note
  Future<bool> updateNote({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final updateNoteUseCase = ref.read(updateNoteUseCaseProvider);
    final result = await updateNoteUseCase(
      id: id,
      title: title,
      contentText: contentText,
      contentJson: contentJson,
      folderId: folderId,
      iconId: iconId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (note) {
        final updatedNotes = state.notes
            .map((n) => n.id == note.id ? note : n)
            .toList();
        state = state.copyWith(
          isLoading: false,
          notes: updatedNotes,
          successMessage: 'Not başarıyla güncellendi',
        );
        return true;
      },
    );
  }

  /// Delete note
  Future<bool> deleteNote(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final deleteNoteUseCase = ref.read(deleteNoteUseCaseProvider);
    final result = await deleteNoteUseCase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        final updatedNotes = state.notes.where((n) => n.id != id).toList();
        state = state.copyWith(
          isLoading: false,
          notes: updatedNotes,
          successMessage: 'Not başarıyla silindi',
        );
        return true;
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success message
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  /// Clear selected note
  void clearSelectedNote() {
    state = state.copyWith(selectedNote: null, error: null);
  }
}

/// Provider
final noteProvider = StateNotifierProvider<NoteNotifier, NoteState>((ref) {
  return NoteNotifier(ref);
});
