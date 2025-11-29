import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/program.dart';
import '../../repositories/program_repository.dart';

class CreateProgramFromText {
  final ProgramRepository repository;

  CreateProgramFromText(this.repository);

  Future<Either<Failure, CreateProgramResponse>> call(String text) async {
    if (text.trim().isEmpty) {
      return Left(ValidationFailure('Lütfen bir metin girin'));
    }
    return await repository.createProgramFromText(text);
  }
}
