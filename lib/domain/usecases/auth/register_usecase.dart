import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/auth_response.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponse>> call({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
