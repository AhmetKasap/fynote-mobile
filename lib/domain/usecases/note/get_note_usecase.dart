import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/note.dart';
import '../../repositories/note_repository.dart';

class GetNoteUseCase {
  final NoteRepository repository;

  GetNoteUseCase(this.repository);

  Future<Either<Failure, NoteEntity>> call(String id) async {
    return await repository.getNote(id);
  }
}
