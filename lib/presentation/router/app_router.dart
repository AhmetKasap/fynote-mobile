import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/folder/folder_form_screen.dart';
import '../screens/note/note_form_screen.dart';
import '../screens/note/note_detail_screen.dart';
import '../screens/program/create_program_screen.dart';
import '../screens/program/program_detail_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String createFolder = '/create-folder';
  static const String editFolder = '/edit-folder';
  static const String createNote = '/create-note';
  static const String editNote = '/edit-note';
  static const String noteDetail = '/note-detail';
  static const String createProgram = '/create-program';
  static const String programDetail = '/program-detail';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),

      // Onboarding
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordScreen(email: email);
        },
      ),

      // Main Routes
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Folder Routes
      GoRoute(
        path: createFolder,
        builder: (context, state) => const FolderFormScreen(),
      ),
      GoRoute(
        path: '$editFolder/:id',
        builder: (context, state) {
          final folderId = state.pathParameters['id'];
          return FolderFormScreen(folderId: folderId);
        },
      ),

      // Note Routes
      GoRoute(
        path: createNote,
        builder: (context, state) => const NoteFormScreen(),
      ),
      GoRoute(
        path: '$editNote/:id',
        builder: (context, state) {
          final noteId = state.pathParameters['id'];
          return NoteFormScreen(noteId: noteId);
        },
      ),
      GoRoute(
        path: '$noteDetail/:id',
        builder: (context, state) {
          final noteId = state.pathParameters['id'];
          return NoteDetailScreen(noteId: noteId!);
        },
      ),

      // Program Routes
      GoRoute(
        path: createProgram,
        builder: (context, state) => const CreateProgramScreen(),
      ),
      GoRoute(
        path: '$programDetail/:id',
        builder: (context, state) {
          final programId = state.pathParameters['id'];
          return ProgramDetailScreen(programId: programId!);
        },
      ),
    ],

    // Error handler
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Sayfa bulunamadı',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(login),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    ),
  );
}
