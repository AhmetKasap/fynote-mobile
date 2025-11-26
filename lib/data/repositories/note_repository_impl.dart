import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes({String? folderId}) async {
    try {
      final result = await remoteDataSource.getNotes(folderId: folderId);
      final notes = result.map((model) => model.toEntity()).toList();
      return Right(notes);
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
  Future<Either<Failure, NoteEntity>> getNote(String id) async {
    try {
      final result = await remoteDataSource.getNote(id);
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
  Future<Either<Failure, NoteEntity>> createNote({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  }) async {
    try {
      final result = await remoteDataSource.createNote(
        title: title,
        contentText: contentText,
        contentJson: contentJson,
        folderId: folderId,
        iconId: iconId,
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
  Future<Either<Failure, NoteEntity>> updateNote({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  }) async {
    try {
      final result = await remoteDataSource.updateNote(
        id: id,
        title: title,
        contentText: contentText,
        contentJson: contentJson,
        folderId: folderId,
        iconId: iconId,
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
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await remoteDataSource.deleteNote(id);
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
