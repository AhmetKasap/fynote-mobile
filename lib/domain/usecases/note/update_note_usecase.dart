import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/note.dart';
import '../../repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<Either<Failure, NoteEntity>> call({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  }) async {
    return await repository.updateNote(
      id: id,
      title: title,
      contentText: contentText,
      contentJson: contentJson,
      folderId: folderId,
      iconId: iconId,
    );
  }
}
