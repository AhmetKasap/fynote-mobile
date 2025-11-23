import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../router/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'FyNote\'a Hoş Geldiniz',
      description:
          'AI ile odaklanın ve not alın – düşüncelerinizi zahmetsizce organize edin.',
      icon: Icons.menu_book_outlined,
      gradient: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
    ),
    OnboardingData(
      title: 'Hızlı Not Alma',
      description: 'Fikirlerinizi bir dokunuşla anında yakalayın.',
      icon: Icons.edit_note_outlined,
      gradient: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
    ),
    OnboardingData(
      title: 'AI Destekli Öneriler',
      description:
          'FyNote notlarınızı otomatik olarak organize eder ve geliştirir.',
      icon: Icons.auto_awesome_outlined,
      gradient: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
    ),
    OnboardingData(
      title: 'Verimliliği Artırın',
      description:
          'Odaklanın, görevlerinizi takip edin ve hiçbir düşünceyi kaçırmayın.',
      icon: Icons.checklist_outlined,
      gradient: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], isDark);
            },
          ),

          // Skip Button - Top Right
          SafeArea(
            child: Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withOpacity(0.7),
                ),
                child: const Text(
                  'Geç',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // Bottom Section - Indicators & Button
          SafeArea(
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _buildIndicator(index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Next/Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1a1a1a),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Başlayalım'
                              : 'İleri',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Icon - Minimal and clean
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(data.icon, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 60),

            // Title - Bold and prominent
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Description - Light and readable
            Text(
              data.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.6,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
