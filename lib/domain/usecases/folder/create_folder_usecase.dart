import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/folder.dart';
import '../../repositories/folder_repository.dart';

class CreateFolderUseCase {
  final FolderRepository repository;

  CreateFolderUseCase(this.repository);

  Future<Either<Failure, FolderEntity>> call({
    required String name,
    String? iconId,
    String? color,
  }) async {
    return await repository.createFolder(
      name: name,
      iconId: iconId,
      color: color,
    );
  }
}
