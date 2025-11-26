import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/folder.dart';
import '../../repositories/folder_repository.dart';

class GetFoldersUseCase {
  final FolderRepository repository;

  GetFoldersUseCase(this.repository);

  Future<Either<Failure, List<FolderEntity>>> call() async {
    return await repository.getFolders();
  }
}
