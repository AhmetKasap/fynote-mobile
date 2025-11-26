import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/folder.dart';
import '../../repositories/folder_repository.dart';

class GetFolderUseCase {
  final FolderRepository repository;

  GetFolderUseCase(this.repository);

  Future<Either<Failure, FolderEntity>> call(String id) async {
    return await repository.getFolder(id);
  }
}
