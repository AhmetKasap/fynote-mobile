import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/verify_email_usecase.dart';
import '../../domain/usecases/user_profile/forgot_password_usecase.dart';
import '../../domain/usecases/user_profile/get_user_profile_usecase.dart';
import '../../domain/usecases/user_profile/reset_password_usecase.dart';
import '../../domain/usecases/user_profile/update_user_profile_usecase.dart';
import 'repository_providers.dart';

// ==================== Auth Use Cases ====================

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyEmailUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

// ==================== User Profile Use Cases ====================

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return ResetPasswordUseCase(repository);
});
