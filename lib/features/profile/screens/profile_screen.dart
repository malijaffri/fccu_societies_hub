import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_colors.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/auth/providers/auth_repository_provider.dart';
import 'package:fccu_societies_hub/features/session/providers/session_repository_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s_24),
                  child: Column(
                    children: [
                      Avatar(avatarUrl: user.avatarUrl, name: user.name, radius: 48),
                      const SizedBox(height: AppSpacing.s_16),
                      Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.s_4),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      if (user.description != null) ...[
                        const SizedBox(height: AppSpacing.s_12),
                        Text(user.description!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile feature coming soon')),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                  title: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.error),
                  onTap: () async {
                    // Clear any leftover guest flag, then sign out.
                    // RouterNotifier detects the auth state change and
                    // redirects to /welcome automatically.
                    await ref.read(sessionRepositoryProvider).clearGuestMode();
                    await ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const AppLoading(),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
