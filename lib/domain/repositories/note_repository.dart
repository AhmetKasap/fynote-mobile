import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<NoteEntity>>> getNotes({String? folderId});
  Future<Either<Failure, NoteEntity>> getNote(String id);
  Future<Either<Failure, NoteEntity>> createNote({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  });
  Future<Either<Failure, NoteEntity>> updateNote({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  });
  Future<Either<Failure, void>> deleteNote(String id);
}
