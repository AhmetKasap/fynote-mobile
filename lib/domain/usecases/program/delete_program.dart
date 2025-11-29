import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/program_repository.dart';

class DeleteProgram {
  final ProgramRepository repository;

  DeleteProgram(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteProgram(id);
  }
}
