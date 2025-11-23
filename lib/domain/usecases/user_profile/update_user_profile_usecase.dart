import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
  }) async {
    return await repository.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }
}
