import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import 'usecase_providers.dart';

/// Auth State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? error,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  /// Register
  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (authResponse) {
        // Register başarılı ama henüz authenticated değil
        // Email doğrulaması yapılana kadar authenticated = false
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          successMessage: 'Kayıt başarılı! Lütfen email adresinizi doğrulayın.',
        );
      },
    );
  }

  /// Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (authResponse) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: authResponse.user,
          successMessage: 'Giriş başarılı!',
        );
      },
    );
  }

  /// Verify Email
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final verifyEmailUseCase = ref.read(verifyEmailUseCaseProvider);
    final result = await verifyEmailUseCase(email: email, code: code);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Email doğrulandı! Giriş yapabilirsiniz.',
        );
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = const AuthState(
          isLoading: false,
          isAuthenticated: false,
          user: null,
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

  /// Update user
  void updateUser(User user) {
    state = state.copyWith(user: user);
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
