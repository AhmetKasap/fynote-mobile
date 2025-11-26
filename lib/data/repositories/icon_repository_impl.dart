import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/icon.dart';
import '../../domain/repositories/icon_repository.dart';
import '../datasources/icon_remote_data_source.dart';

class IconRepositoryImpl implements IconRepository {
  final IconRemoteDataSource remoteDataSource;

  IconRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IconEntity>>> getIcons() async {
    try {
      final result = await remoteDataSource.getIcons();
      final icons = result.map((model) => model.toEntity()).toList();
      return Right(icons);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
