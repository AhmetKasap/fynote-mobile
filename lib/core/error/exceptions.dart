/// Base exception sınıfı
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  ServerException([String message = 'Sunucu hatası', int? statusCode])
    : super(message, statusCode);
}

/// Network exception
class NetworkException extends AppException {
  NetworkException([String message = 'İnternet bağlantısı yok'])
    : super(message);
}

/// Cache exception
class CacheException extends AppException {
  CacheException([String message = 'Önbellek hatası']) : super(message);
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException([
    String message = 'Girilen bilgiler geçersiz',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Authentication exception
class AuthException extends AppException {
  AuthException([String message = 'Kimlik doğrulama hatası', int? statusCode])
    : super(message, statusCode);
}

/// Not Found exception
class NotFoundException extends AppException {
  NotFoundException([String message = 'İçerik bulunamadı', int? statusCode])
    : super(message, statusCode);
}

/// Unauthorized exception
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Yetkiniz yok', int? statusCode])
    : super(message, statusCode);
}
