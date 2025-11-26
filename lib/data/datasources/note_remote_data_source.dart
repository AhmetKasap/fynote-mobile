import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes({String? folderId});
  Future<NoteModel> getNote(String id);
  Future<NoteModel> createNote({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  });
  Future<NoteModel> updateNote({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  });
  Future<void> deleteNote(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final Dio dio;

  NoteRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NoteModel>> getNotes({String? folderId}) async {
    try {
      final response = await dio.get(
        ApiConstants.notes,
        queryParameters: folderId != null ? {'folderId': folderId} : null,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Notlar getirilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<NoteModel> getNote(String id) async {
    try {
      final response = await dio.get(ApiConstants.note(id));

      if (response.statusCode == 200) {
        return NoteModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Not getirilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<NoteModel> createNote({
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    String? folderId,
    String? iconId,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.notes,
        data: {
          'title': title,
          'contentText': contentText,
          'contentJson': contentJson,
          if (folderId != null) 'folderId': folderId,
          if (iconId != null) 'iconId': iconId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NoteModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Not oluşturulamadı',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<NoteModel> updateNote({
    required String id,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    String? folderId,
    String? iconId,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.note(id),
        data: {
          if (title != null) 'title': title,
          if (contentText != null) 'contentText': contentText,
          if (contentJson != null) 'contentJson': contentJson,
          if (folderId != null) 'folderId': folderId,
          if (iconId != null) 'iconId': iconId,
        },
      );

      if (response.statusCode == 200) {
        return NoteModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Not güncellenemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final response = await dio.delete(ApiConstants.note(id));

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Not silinemedi',
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
