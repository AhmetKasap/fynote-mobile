import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import 'auth_provider.dart';
import 'usecase_providers.dart';

/// User Profile State
class UserProfileState {
  final bool isLoading;
  final User? user;
  final String? error;
  final String? successMessage;

  const UserProfileState({
    this.isLoading = false,
    this.user,
    this.error,
    this.successMessage,
  });

  UserProfileState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    String? successMessage,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// User Profile Notifier
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final Ref ref;

  UserProfileNotifier(this.ref) : super(const UserProfileState());

  /// Get User Profile
  Future<void> getUserProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final getUserProfileUseCase = ref.read(getUserProfileUseCaseProvider);
    final result = await getUserProfileUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        // Auth provider'daki user'ı da güncelle
        ref.read(authProvider.notifier).updateUser(user);
      },
    );
  }

  /// Update User Profile
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final updateUserProfileUseCase = ref.read(updateUserProfileUseCaseProvider);
    final result = await updateUserProfileUseCase(
      firstName: firstName,
      lastName: lastName,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          successMessage: 'Profil başarıyla güncellendi',
        );
        // Auth provider'daki user'ı da güncelle
        ref.read(authProvider.notifier).updateUser(user);
      },
    );
  }

  /// Forgot Password
  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);

    final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
    final result = await forgotPasswordUseCase(email: email);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Şifre sıfırlama kodu email adresinize gönderildi',
        );
      },
    );
  }

  /// Reset Password
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
    final result = await resetPasswordUseCase(
      email: email,
      code: code,
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Şifreniz başarıyla sıfırlandı',
        );
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
}

/// User Profile Provider
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
      return UserProfileNotifier(ref);
    });
