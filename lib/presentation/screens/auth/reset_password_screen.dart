import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../providers/user_profile_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userProfileProvider.notifier)
          .resetPassword(
            email: widget.email,
            code: _codeController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);

    // Listen to state changes
    ref.listen<UserProfileState>(userProfileProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(userProfileProvider.notifier).clearError();
      }

      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
          ),
        );
        ref.read(userProfileProvider.notifier).clearSuccessMessage();

        // Login sayfasına yönlendir
        context.go(AppRouter.login);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Şifre Sıfırla',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.email} adresine gönderilen kodu girin ve yeni şifrenizi belirleyin',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Code Field
                CustomTextField(
                  controller: _codeController,
                  label: 'Doğrulama Kodu',
                  hint: '000000',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: Validators.verificationCode,
                  prefixIcon: const Icon(Icons.pin_outlined),
                ),
                const SizedBox(height: 20),

                // New Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Yeni Şifre',
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Yeni Şifre Tekrar',
                  hint: '••••••••',
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Reset Button
                CustomButton(
                  text: 'Şifreyi Sıfırla',
                  onPressed: _resetPassword,
                  isLoading: profileState.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
