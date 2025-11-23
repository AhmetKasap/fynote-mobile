import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mevcut kullanıcı bilgilerini doldur
    Future.microtask(() {
      final user = ref.read(authProvider).user;
      if (user != null) {
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userProfileProvider.notifier)
          .updateUserProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final user = ref.watch(authProvider).user;

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

        // Geri dön
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    user?.initials ?? '?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Email (Read-only)
                CustomTextField(
                  controller: TextEditingController(text: user?.email ?? ''),
                  label: 'Email',
                  enabled: false,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 20),

                // First Name
                CustomTextField(
                  controller: _firstNameController,
                  label: 'Ad',
                  hint: 'Adınız',
                  validator: (value) => Validators.name(value, fieldName: 'Ad'),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 20),

                // Last Name
                CustomTextField(
                  controller: _lastNameController,
                  label: 'Soyad',
                  hint: 'Soyadınız',
                  validator: (value) =>
                      Validators.name(value, fieldName: 'Soyad'),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 32),

                // Update Button
                CustomButton(
                  text: 'Güncelle',
                  onPressed: _updateProfile,
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
