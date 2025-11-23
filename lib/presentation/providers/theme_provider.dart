import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme State
class ThemeState {
  final ThemeMode themeMode;
  final bool isLoading;

  const ThemeState({this.themeMode = ThemeMode.dark, this.isLoading = true});

  ThemeState copyWith({ThemeMode? themeMode, bool? isLoading}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Theme Notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState()) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);

    ThemeMode themeMode;
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
        themeMode = ThemeMode.system;
        break;
      default:
        themeMode = ThemeMode.dark; // Varsayılan olarak dark mode
    }

    state = state.copyWith(themeMode: themeMode, isLoading: false);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    String themeModeString;
    switch (mode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await prefs.setString(_themeKey, themeModeString);
    state = state.copyWith(themeMode: mode);
  }

  void toggleTheme(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

/// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
