import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/icon.dart';
import 'usecase_providers.dart';

/// Icon State
class IconState {
  final bool isLoading;
  final List<IconEntity> icons;
  final String? error;

  const IconState({this.isLoading = false, this.icons = const [], this.error});

  IconState copyWith({
    bool? isLoading,
    List<IconEntity>? icons,
    String? error,
  }) {
    return IconState(
      isLoading: isLoading ?? this.isLoading,
      icons: icons ?? this.icons,
      error: error,
    );
  }
}

/// Icon State Notifier
class IconNotifier extends StateNotifier<IconState> {
  final Ref ref;

  IconNotifier(this.ref) : super(const IconState());

  /// Get all icons
  Future<void> getIcons() async {
    state = state.copyWith(isLoading: true, error: null);

    final getIconsUseCase = ref.read(getIconsUseCaseProvider);
    final result = await getIconsUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (icons) {
        state = state.copyWith(isLoading: false, icons: icons);
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider
final iconProvider = StateNotifierProvider<IconNotifier, IconState>((ref) {
  return IconNotifier(ref);
});
