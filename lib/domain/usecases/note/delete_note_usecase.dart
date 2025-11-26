import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteNote(id);
  }
}
