import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/repository_providers.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isResending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .verifyEmail(email: widget.email, code: _codeController.text.trim());
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.resendVerificationEmail(email: widget.email);

    setState(() => _isResending = false);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Doğrulama kodu tekrar gönderildi'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }

      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
          ),
        );
        ref.read(authProvider.notifier).clearSuccessMessage();

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
                  'Email Doğrulama',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.email} adresine gönderilen 6 haneli doğrulama kodunu girin',
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
                const SizedBox(height: 32),

                // Verify Button
                CustomButton(
                  text: 'Doğrula',
                  onPressed: _verifyEmail,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 24),

                // Resend Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kod almadınız mı? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: _isResending ? null : _resendCode,
                      child: _isResending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Tekrar Gönder'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
