import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../router/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context, WidgetRef ref) async {
    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final themeState = ref.watch(themeProvider);
    final isDark =
        themeState.themeMode == ThemeMode.dark ||
        (themeState.themeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // User Avatar
          Center(
            child: CircleAvatar(
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
          ),
          const SizedBox(height: 24),

          // User Name
          Text(
            user?.fullName ?? 'Kullanıcı',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // User Email
          Text(
            user?.email ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Appearance
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  title: const Text('Karanlık Mod'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Profile Options
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Profili Düzenle'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push(AppRouter.editProfile);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Şifre Değiştir'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push(AppRouter.forgotPassword);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // App Info
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Uygulama Hakkında'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'FyNote',
                      applicationVersion: '1.0.0',
                      applicationIcon: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.note_alt_outlined,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      children: [
                        const Text('AI destekli akıllı not uygulaması'),
                      ],
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Gizlilik Politikası'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gizlilik politikası sayfası yakında'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Kullanım Koşulları'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kullanım koşulları sayfası yakında'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => _logout(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
