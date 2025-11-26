import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/icon.dart';
import '../../repositories/icon_repository.dart';

class GetIconsUseCase {
  final IconRepository repository;

  GetIconsUseCase(this.repository);

  Future<Either<Failure, List<IconEntity>>> call() async {
    return await repository.getIcons();
  }
}
