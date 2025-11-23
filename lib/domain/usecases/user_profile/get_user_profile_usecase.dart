import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getUserProfile();
  }
}
