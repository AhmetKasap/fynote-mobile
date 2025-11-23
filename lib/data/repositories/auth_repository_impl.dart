import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final result = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      // Token'ı kaydet
      await secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: result.accessToken,
      );

      if (result.refreshToken != null) {
        await secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: result.refreshToken,
        );
      }

      // AuthResponse entity'sine dönüştür
      final authResponse = AuthResponse(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        user: User(
          id: result.user.id,
          email: result.user.email,
          firstName: result.user.firstName,
          lastName: result.user.lastName,
          createdAt: result.user.createdAt,
          updatedAt: result.user.updatedAt,
        ),
        message: result.message,
      );

      return Right(authResponse);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Token'ı kaydet
      await secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: result.accessToken,
      );

      if (result.refreshToken != null) {
        await secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: result.refreshToken,
        );
      }

      // AuthResponse entity'sine dönüştür
      final authResponse = AuthResponse(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        user: User(
          id: result.user.id,
          email: result.user.email,
          firstName: result.user.firstName,
          lastName: result.user.lastName,
          createdAt: result.user.createdAt,
          updatedAt: result.user.updatedAt,
        ),
        message: result.message,
      );

      return Right(authResponse);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await remoteDataSource.verifyEmail(email: email, code: code);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.resendVerificationEmail(email: email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Token'ları temizle
      await secureStorage.delete(key: AppConstants.accessTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await secureStorage.read(key: AppConstants.accessTokenKey);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
