import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/icon_model.dart';

abstract class IconRemoteDataSource {
  Future<List<IconModel>> getIcons();
}

class IconRemoteDataSourceImpl implements IconRemoteDataSource {
  final Dio dio;

  IconRemoteDataSourceImpl(this.dio);

  @override
  Future<List<IconModel>> getIcons() async {
    try {
      final response = await dio.get(ApiConstants.icons);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => IconModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'İkonlar getirilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Bağlantı zaman aşımına uğradı');
      }

      if (e.type == DioExceptionType.unknown) {
        throw NetworkException('İnternet bağlantısı yok');
      }

      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Bir hata oluştu';

      if (statusCode == 401) {
        throw AuthException(message, statusCode);
      } else if (statusCode == 404) {
        throw NotFoundException(message, statusCode);
      } else {
        throw ServerException(message, statusCode);
      }
    }
  }
}
