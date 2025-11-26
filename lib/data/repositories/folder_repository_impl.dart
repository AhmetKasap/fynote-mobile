import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/folder.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/folder_remote_data_source.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource remoteDataSource;

  FolderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FolderEntity>>> getFolders() async {
    try {
      final result = await remoteDataSource.getFolders();
      final folders = result.map((model) => model.toEntity()).toList();
      return Right(folders);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FolderEntity>> getFolder(String id) async {
    try {
      final result = await remoteDataSource.getFolder(id);
      return Right(result.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FolderEntity>> createFolder({
    required String name,
    String? iconId,
    String? color,
  }) async {
    try {
      final result = await remoteDataSource.createFolder(
        name: name,
        iconId: iconId,
        color: color,
      );
      return Right(result.toEntity());
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
  Future<Either<Failure, FolderEntity>> updateFolder({
    required String id,
    String? name,
    String? iconId,
    String? color,
  }) async {
    try {
      final result = await remoteDataSource.updateFolder(
        id: id,
        name: name,
        iconId: iconId,
        color: color,
      );
      return Right(result.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFolder(String id) async {
    try {
      await remoteDataSource.deleteFolder(id);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
