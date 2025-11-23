import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/repository_providers.dart';
import '../router/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // 2 saniye bekle (splash animasyonu için)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Onboarding kontrolü
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      // İlk kez açılıyor, onboarding'e yönlendir
      context.go(AppRouter.onboarding);
      return;
    }

    // Token kontrolü
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.isLoggedIn();

    result.fold(
      (failure) {
        // Hata durumunda login'e yönlendir
        context.go(AppRouter.login);
      },
      (isLoggedIn) {
        if (isLoggedIn) {
          // Kullanıcı giriş yapmış, home'a yönlendir
          context.go(AppRouter.home);
        } else {
          // Kullanıcı giriş yapmamış, login'e yönlendir
          context.go(AppRouter.login);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minimalist Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // App Name
              const Text(
                'FyNote',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                'Focus and Note with AI',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),

              // Loading Indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
