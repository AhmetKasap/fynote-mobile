/// Uygulama genelinde kullanılan sabitler
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'FyNote';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String themeMode = 'theme_mode';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int verificationCodeLength = 6;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
