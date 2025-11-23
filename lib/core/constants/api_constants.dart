/// API ve network sabitleri
class ApiConstants {
  ApiConstants._();

  // Base URL - Gerçek API URL'inizi buraya yazın
  static const String baseUrl =
      'http://t84ss0cgw4w0kk4kwo4ccs4o.185.240.104.160.sslip.io';

  // API Endpoints
  static const String apiVersion = '/api/v1';

  // Auth Endpoints
  static const String register = '$apiVersion/auth/register';
  static const String login = '$apiVersion/auth/login';
  static const String verifyEmail = '$apiVersion/auth/verify-email';
  static const String resendVerificationEmail =
      '$apiVersion/auth/resend-verification-email';
  static const String authTest = '$apiVersion/auth/test';

  // User Profile Endpoints
  static const String userProfile = '$apiVersion/user-profile';
  static const String forgotPassword =
      '$apiVersion/user-profile/forgot-password';
  static const String resetPassword = '$apiVersion/user-profile/reset-password';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
