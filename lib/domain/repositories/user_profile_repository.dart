import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, User>> getUserProfile();

  Future<Either<Failure, User>> updateUserProfile({
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String password,
  });
}
