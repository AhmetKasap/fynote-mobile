import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/folder_repository.dart';

class DeleteFolderUseCase {
  final FolderRepository repository;

  DeleteFolderUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteFolder(id);
  }
}
