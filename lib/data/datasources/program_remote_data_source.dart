import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/program_model.dart';

abstract class ProgramRemoteDataSource {
  Future<List<ProgramModel>> getPrograms();
  Future<ProgramModel> getProgramById(String id);
  Future<CreateProgramResponseModel> createProgramFromText(String text);
  Future<CreateProgramResponseModel> createProgramFromAudio(File audioFile);
  Future<void> deleteProgram(String id);
}

class ProgramRemoteDataSourceImpl implements ProgramRemoteDataSource {
  final Dio dio;

  ProgramRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProgramModel>> getPrograms() async {
    try {
      final response = await dio.get(ApiConstants.programs);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => ProgramModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Programlar getirilemedi',
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

  @override
  Future<ProgramModel> getProgramById(String id) async {
    try {
      final response = await dio.get(ApiConstants.program(id));

      if (response.statusCode == 200) {
        return ProgramModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Program getirilemedi',
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

  @override
  Future<CreateProgramResponseModel> createProgramFromText(String text) async {
    try {
      final response = await dio.post(
        ApiConstants.programFromText,
        data: {'text': text},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateProgramResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Program oluşturulamadı',
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
      } else if (statusCode == 400) {
        throw ValidationException(message, statusCode);
      } else {
        throw ServerException(message, statusCode);
      }
    }
  }

  @override
  Future<CreateProgramResponseModel> createProgramFromAudio(
    File audioFile,
  ) async {
    try {
      // Multipart form data oluştur
      final fileName = audioFile.path.split('/').last;
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: fileName,
          contentType: MediaType('audio', 'wav'),
        ),
      });

      final response = await dio.post(
        ApiConstants.programFromAudio,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateProgramResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Program oluşturulamadı',
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
      } else if (statusCode == 400) {
        throw ValidationException(message, statusCode);
      } else {
        throw ServerException(message, statusCode);
      }
    }
  }

  @override
  Future<void> deleteProgram(String id) async {
    try {
      final response = await dio.delete(ApiConstants.program(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          response.data['message'] ?? 'Program silinemedi',
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
