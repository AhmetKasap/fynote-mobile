import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserModel> getUserProfile();

  Future<UserModel> updateUserProfile({
    required String firstName,
    required String lastName,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;

  UserProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await dio.get(ApiConstants.userProfile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Profil bilgileri alınamadı',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.userProfile,
        data: {'firstName': firstName, 'lastName': lastName},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Profil güncellenemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Şifre sıfırlama kodu gönderilemedi',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPassword,
        data: {'email': email, 'code': code, 'password': password},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Şifre sıfırlanamadı',
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
      throw UnauthorizedException(message, statusCode);
    } else if (statusCode == 404) {
      throw NotFoundException(message, statusCode);
    } else {
      throw ServerException(message, statusCode);
    }
  }
}
