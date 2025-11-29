import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/program.dart';
import '../../repositories/program_repository.dart';

class CreateProgramFromAudio {
  final ProgramRepository repository;

  CreateProgramFromAudio(this.repository);

  Future<Either<Failure, CreateProgramResponse>> call(File audioFile) async {
    if (!audioFile.existsSync()) {
      return Left(ValidationFailure('Ses dosyası bulunamadı'));
    }
    return await repository.createProgramFromAudio(audioFile);
  }
}
