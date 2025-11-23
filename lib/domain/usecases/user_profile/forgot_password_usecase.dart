import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/user_profile_repository.dart';

class ForgotPasswordUseCase {
  final UserProfileRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) async {
    return await repository.forgotPassword(email: email);
  }
}
