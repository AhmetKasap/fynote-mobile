import 'package:flutter/material.dart';

/// String extensions
extension StringExtension on String {
  /// String'i capitalize et
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// String'in baş ve son boşluklarını temizle
  String get trimAll => trim();

  /// Email validasyonu
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Boş mu kontrolü
  bool get isEmptyOrNull => isEmpty;
}

/// BuildContext extensions
extension BuildContextExtension on BuildContext {
  /// MediaQuery shortcuts
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Navigation shortcuts
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(
      this,
    ).pushReplacement<T, T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Snackbar helper
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Loading dialog helper
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }
}

/// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Format: 12 Ocak 2024
  String get formattedDate {
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Format: 12.01.2024
  String get shortDate =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';

  /// Format: 14:30
  String get timeOnly =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
