import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/note.dart';
import '../../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Future<Either<Failure, List<NoteEntity>>> call({String? folderId}) async {
    return await repository.getNotes(folderId: folderId);
  }
}
