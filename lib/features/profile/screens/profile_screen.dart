import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_colors.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/auth/providers/auth_repository_provider.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_card.dart';
import 'package:fccu_societies_hub/features/session/providers/session_repository_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

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
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),

      body: userAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final postsAsync = ref.watch(userPostsProvider(user.id));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserModelProvider);
              ref.invalidate(userPostsProvider(user.id));
            },
            child: CustomScrollView(
              slivers: [
                // ── Header ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s_24),
                    child: Column(
                      children: [
                        Avatar(avatarUrl: user.avatarUrl, name: user.name, radius: 48),
                        const SizedBox(height: AppSpacing.s_16),
                        Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.s_4),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                        if (user.description != null) ...[
                          const SizedBox(height: AppSpacing.s_12),
                          Text(
                            user.description!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.s_20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => context.push(AppRoutes.editProfile),
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text('Edit Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: Divider(height: 1)),

                // ── Sign-out tile ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                    title: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.error),
                    onTap: () async {
                      await ref.read(sessionRepositoryProvider).clearGuestMode();
                      await ref.read(authRepositoryProvider).signOut();
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: Divider(height: 1)),

                // ── My Posts heading ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s_16, AppSpacing.s_20,
                      AppSpacing.s_16, AppSpacing.s_12,
                    ),
                    child: Text('My Posts', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),

                // ── My Posts list ──────────────────────────────────────
                postsAsync.when(
                  loading: () => const SliverToBoxAdapter(child: AppLoading()),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s_16),
                      child: Text('Could not load posts: $e'),
                    ),
                  ),
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: EmptyState(
                          icon: Icons.forum_outlined,
                          title: 'No posts yet',
                          subtitle: 'Your posts will appear here.',
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.s_16, 0,
                        AppSpacing.s_16, AppSpacing.s_24,
                      ),
                      sliver: SliverList.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_16),
                        itemBuilder: (_, i) => PostCard(post: posts[i]),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
