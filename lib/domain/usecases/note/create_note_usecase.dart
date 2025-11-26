import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/note.dart';
import '../../repositories/note_repository.dart';

class CreateNoteUseCase {
  final NoteRepository repository;

  CreateNoteUseCase(this.repository);

  Future<Either<Failure, NoteEntity>> call({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  }) async {
    return await repository.createNote(
      title: title,
      contentText: contentText,
      contentJson: contentJson,
      folderId: folderId,
      iconId: iconId,
    );
  }
}
