import 'package:equatable/equatable.dart';

/// Base failure sınıfı
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server hatası
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Sunucu hatası oluştu'])
    : super(message);
}

/// Network hatası (internet bağlantısı yok)
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'İnternet bağlantısı yok'])
    : super(message);
}

/// Cache hatası
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Önbellek hatası']) : super(message);
}

/// Validation hatası
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Girilen bilgiler geçersiz'])
    : super(message);
}

/// Authentication hatası
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Kimlik doğrulama hatası'])
    : super(message);
}

/// Not Found hatası
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'İçerik bulunamadı'])
    : super(message);
}

/// Unauthorized hatası
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Yetkiniz yok']) : super(message);
}

/// Generic hatası
class GenericFailure extends Failure {
  const GenericFailure([String message = 'Bir hata oluştu']) : super(message);
}
