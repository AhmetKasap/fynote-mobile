import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/folder.dart';

abstract class FolderRepository {
  Future<Either<Failure, List<FolderEntity>>> getFolders();
  Future<Either<Failure, FolderEntity>> getFolder(String id);
  Future<Either<Failure, FolderEntity>> createFolder({
    required String name,
    String? iconId,
    String? color,
  });
  Future<Either<Failure, FolderEntity>> updateFolder({
    required String id,
    String? name,
    String? iconId,
    String? color,
  });
  Future<Either<Failure, void>> deleteFolder(String id);
}
