import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/icon.dart';

abstract class IconRepository {
  Future<Either<Failure, List<IconEntity>>> getIcons();
}
