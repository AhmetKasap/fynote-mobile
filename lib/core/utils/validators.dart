import '../constants/app_constants.dart';

/// Form validation yardımcı fonksiyonları
class Validators {
  Validators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email adresi gerekli';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email adresi girin';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Şifre en az ${AppConstants.minPasswordLength} karakter olmalı';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Şifre en fazla ${AppConstants.maxPasswordLength} karakter olabilir';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Bu alan'} gerekli';
    }
    return null;
  }

  /// Name validation
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'İsim'} gerekli';
    }

    if (value.length < 2) {
      return '${fieldName ?? 'İsim'} en az 2 karakter olmalı';
    }

    if (value.length > 50) {
      return '${fieldName ?? 'İsim'} en fazla 50 karakter olabilir';
    }

    return null;
  }

  /// Verification code validation
  static String? verificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Doğrulama kodu gerekli';
    }

    if (value.length != AppConstants.verificationCodeLength) {
      return 'Doğrulama kodu ${AppConstants.verificationCodeLength} haneli olmalı';
    }

    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı gerekli';
    }

    if (value != password) {
      return 'Şifreler eşleşmiyor';
    }

    return null;
  }

  /// Phone number validation (optional)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Geçerli bir telefon numarası girin';
    }

    return null;
  }
}
