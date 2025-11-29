import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/program.dart';

abstract class ProgramRepository {
  /// Tüm programları getir
  Future<Either<Failure, List<Program>>> getPrograms();

  /// ID'ye göre program getir
  Future<Either<Failure, Program>> getProgramById(String id);

  /// Metinden program oluştur
  Future<Either<Failure, CreateProgramResponse>> createProgramFromText(
    String text,
  );

  /// Ses dosyasından program oluştur
  Future<Either<Failure, CreateProgramResponse>> createProgramFromAudio(
    File audioFile,
  );

  /// Program sil
  Future<Either<Failure, void>> deleteProgram(String id);
}
