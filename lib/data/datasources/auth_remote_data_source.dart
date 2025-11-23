import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> verifyEmail({required String email, required String code});

  Future<void> resendVerificationEmail({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Register işlemi başarılı ama henüz user bilgisi yok
        // Email doğrulaması yapılana kadar dummy bir response dönüyoruz
        final authData = {
          'accessToken': 'pending_verification', // Geçici token
          'user': {
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
          },
          'message': response.data['message'],
        };

        return AuthResponseModel.fromJson(authData);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Kayıt başarısız',
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

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API response yapısını parse et
        final data = response.data['data'];

        // AuthResponseModel için uygun formata dönüştür
        final authData = {
          'accessToken': data['token'],
          'user': {
            'id': data['id'],
            'email': data['email'],
            'firstName': data['firstName'],
            'lastName': data['lastName'],
            'createdAt': data['createdAt'],
            'updatedAt': data['updatedAt'],
          },
          'message': response.data['message'],
        };

        return AuthResponseModel.fromJson(authData);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Giriş başarısız',
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

  @override
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyEmail,
        data: {'email': email, 'code': code},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Doğrulama başarısız',
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

      if (statusCode == 400) {
        throw ValidationException(message);
      } else if (statusCode == 401) {
        throw AuthException(message, statusCode);
      } else {
        throw ServerException(message, statusCode);
      }
    }
  }

  @override
  Future<void> resendVerificationEmail({required String email}) async {
    try {
      final response = await dio.post(
        ApiConstants.resendVerificationEmail,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Doğrulama kodu gönderilemedi',
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

      throw ServerException(message, statusCode);
    }
  }
}
