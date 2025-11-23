import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resendVerificationEmail({
    required String email,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}
