import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/program.dart';
import '../../domain/repositories/program_repository.dart';
import '../datasources/program_remote_data_source.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  final ProgramRemoteDataSource remoteDataSource;

  ProgramRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Program>>> getPrograms() async {
    try {
      final programs = await remoteDataSource.getPrograms();
      return Right(programs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, Program>> getProgramById(String id) async {
    try {
      final program = await remoteDataSource.getProgramById(id);
      return Right(program);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, CreateProgramResponse>> createProgramFromText(
    String text,
  ) async {
    try {
      final response = await remoteDataSource.createProgramFromText(text);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, CreateProgramResponse>> createProgramFromAudio(
    File audioFile,
  ) async {
    try {
      final response = await remoteDataSource.createProgramFromAudio(audioFile);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProgram(String id) async {
    try {
      await remoteDataSource.deleteProgram(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }
}
