import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/user_profile_repository.dart';

class ResetPasswordUseCase {
  final UserProfileRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
    required String password,
  }) async {
    return await repository.resetPassword(
      email: email,
      code: code,
      password: password,
    );
  }
}
