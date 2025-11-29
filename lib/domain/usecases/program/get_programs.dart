import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/program.dart';
import '../../repositories/program_repository.dart';

class GetPrograms {
  final ProgramRepository repository;

  GetPrograms(this.repository);

  Future<Either<Failure, List<Program>>> call() async {
    return await repository.getPrograms();
  }
}
