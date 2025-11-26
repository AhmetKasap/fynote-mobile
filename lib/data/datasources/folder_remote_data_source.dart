import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/folder_model.dart';

abstract class FolderRemoteDataSource {
  Future<List<FolderModel>> getFolders();
  Future<FolderModel> getFolder(String id);
  Future<FolderModel> createFolder({
    required String name,
    String? iconId,
    String? color,
  });
  Future<FolderModel> updateFolder({
    required String id,
    String? name,
    String? iconId,
    String? color,
  });
  Future<void> deleteFolder(String id);
}

class FolderRemoteDataSourceImpl implements FolderRemoteDataSource {
  final Dio dio;

  FolderRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FolderModel>> getFolders() async {
    try {
      final response = await dio.get(ApiConstants.folders);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => FolderModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Klasörler getirilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<FolderModel> getFolder(String id) async {
    try {
      final response = await dio.get(ApiConstants.folder(id));

      if (response.statusCode == 200) {
        return FolderModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Klasör getirilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<FolderModel> createFolder({
    required String name,
    String? iconId,
    String? color,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.folders,
        data: {
          'name': name,
          if (iconId != null) 'iconId': iconId,
          if (color != null) 'color': color,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FolderModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Klasör oluşturulamadı',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<FolderModel> updateFolder({
    required String id,
    String? name,
    String? iconId,
    String? color,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.folder(id),
        data: {
          if (name != null) 'name': name,
          if (iconId != null) 'iconId': iconId,
          if (color != null) 'color': color,
        },
      );

      if (response.statusCode == 200) {
        return FolderModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Klasör güncellenemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> deleteFolder(String id) async {
    try {
      final response = await dio.delete(ApiConstants.folder(id));

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Klasör silinemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
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

    if (statusCode == 400) {
      throw ValidationException(message);
    } else if (statusCode == 401) {
      throw AuthException(message, statusCode);
    } else if (statusCode == 404) {
      throw NotFoundException(message, statusCode);
    } else {
      throw ServerException(message, statusCode);
    }
  }
}
