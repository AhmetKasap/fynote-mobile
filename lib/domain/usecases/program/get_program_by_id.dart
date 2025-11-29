import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/program.dart';
import '../../repositories/program_repository.dart';

class GetProgramById {
  final ProgramRepository repository;

  GetProgramById(this.repository);

  Future<Either<Failure, Program>> call(String id) async {
    return await repository.getProgramById(id);
  }
}
