import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Dio interceptor - Token yönetimi ve hata yakalama
class DioInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  DioInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Token'ı al ve header'a ekle
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Response başarılı
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401 hatası - Token geçersiz, kullanıcıyı çıkış yaptır
    if (err.response?.statusCode == 401) {
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      // TODO: Navigate to login page
    }

    return handler.next(err);
  }
}
