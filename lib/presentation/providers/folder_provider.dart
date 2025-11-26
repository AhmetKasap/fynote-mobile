import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/folder.dart';
import 'usecase_providers.dart';

/// Folder State
class FolderState {
  final bool isLoading;
  final List<FolderEntity> folders;
  final FolderEntity? selectedFolder;
  final String? error;
  final String? successMessage;

  const FolderState({
    this.isLoading = false,
    this.folders = const [],
    this.selectedFolder,
    this.error,
    this.successMessage,
  });

  FolderState copyWith({
    bool? isLoading,
    List<FolderEntity>? folders,
    Object? selectedFolder = const _Undefined(),
    String? error,
    String? successMessage,
  }) {
    return FolderState(
      isLoading: isLoading ?? this.isLoading,
      folders: folders ?? this.folders,
      selectedFolder: selectedFolder == const _Undefined()
          ? this.selectedFolder
          : selectedFolder as FolderEntity?,
      error: error,
      successMessage: successMessage,
    );
  }
}

class _Undefined {
  const _Undefined();
}

/// Folder State Notifier
class FolderNotifier extends StateNotifier<FolderState> {
  final Ref ref;

  FolderNotifier(this.ref) : super(const FolderState());

  /// Get all folders
  Future<void> getFolders() async {
    state = state.copyWith(isLoading: true, error: null);

    final getFoldersUseCase = ref.read(getFoldersUseCaseProvider);
    final result = await getFoldersUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (folders) {
        state = state.copyWith(isLoading: false, folders: folders);
      },
    );
  }

  /// Get folder by id
  Future<void> getFolder(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final getFolderUseCase = ref.read(getFolderUseCaseProvider);
    final result = await getFolderUseCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (folder) {
        state = state.copyWith(isLoading: false, selectedFolder: folder);
      },
    );
  }

  /// Create folder
  Future<bool> createFolder({
    required String name,
    String? iconId,
    String? color,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final createFolderUseCase = ref.read(createFolderUseCaseProvider);
    final result = await createFolderUseCase(
      name: name,
      iconId: iconId,
      color: color,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (folder) {
        final updatedFolders = [...state.folders, folder];
        state = state.copyWith(
          isLoading: false,
          folders: updatedFolders,
          successMessage: 'Klasör başarıyla oluşturuldu',
        );
        return true;
      },
    );
  }

  /// Update folder
  Future<bool> updateFolder({
    required String id,
    String? name,
    String? iconId,
    String? color,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final updateFolderUseCase = ref.read(updateFolderUseCaseProvider);
    final result = await updateFolderUseCase(
      id: id,
      name: name,
      iconId: iconId,
      color: color,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (folder) {
        final updatedFolders = state.folders
            .map((f) => f.id == folder.id ? folder : f)
            .toList();
        state = state.copyWith(
          isLoading: false,
          folders: updatedFolders,
          successMessage: 'Klasör başarıyla güncellendi',
        );
        return true;
      },
    );
  }

  /// Delete folder
  Future<bool> deleteFolder(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final deleteFolderUseCase = ref.read(deleteFolderUseCaseProvider);
    final result = await deleteFolderUseCase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        final updatedFolders = state.folders.where((f) => f.id != id).toList();
        state = state.copyWith(
          isLoading: false,
          folders: updatedFolders,
          successMessage: 'Klasör başarıyla silindi',
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

  /// Clear selected folder
  void clearSelectedFolder() {
    state = state.copyWith(selectedFolder: null, error: null);
  }
}

/// Provider
final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>((
  ref,
) {
  return FolderNotifier(ref);
});
