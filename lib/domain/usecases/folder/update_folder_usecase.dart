import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/folder.dart';
import '../../repositories/folder_repository.dart';

class UpdateFolderUseCase {
  final FolderRepository repository;

  UpdateFolderUseCase(this.repository);

  Future<Either<Failure, FolderEntity>> call({
    required String id,
    String? name,
    String? iconId,
    String? color,
  }) async {
    return await repository.updateFolder(
      id: id,
      name: name,
      iconId: iconId,
      color: color,
    );
  }
}
