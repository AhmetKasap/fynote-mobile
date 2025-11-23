import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
  }) async {
    return await repository.verifyEmail(email: email, code: code);
  }
}
