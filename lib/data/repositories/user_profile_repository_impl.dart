import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();

      // User entity'sine dönüştür
      final user = User(
        id: result.id,
        email: result.email,
        firstName: result.firstName,
        lastName: result.lastName,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      );

      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final result = await remoteDataSource.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
      );

      // User entity'sine dönüştür
      final user = User(
        id: result.id,
        email: result.email,
        firstName: result.firstName,
        lastName: result.lastName,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      );

      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        code: code,
        password: password,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
