import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/feed/providers/feed_provider.dart';
import 'package:fccu_societies_hub/features/post/widgets/post_card.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostsList extends ConsumerWidget {
  final bool Function(Post)? filter;
  final String? filterFailMsg;

  const PostsList({super.key, this.filter, this.filterFailMsg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedProvider);

          await ref.read(feedProvider.future);
        },

        child: postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const EmptyState(
                icon: Icons.forum_outlined,
                title: 'No posts yet',
                subtitle: 'Posts from societies will appear here.',
              );
            }

            final filtered = filter != null ? posts.where(filter!).toList() : posts;

            if (filtered.isEmpty) {
              return EmptyState(
                icon: Icons.forum_outlined,
                title: 'No posts found',
                subtitle: filterFailMsg != null ? filterFailMsg! : 'Posts from societies will appear here.',
              );
            }

            return ListView.separated(
              padding: const .symmetric(vertical: AppSpacing.s_12),

              itemCount: filtered.length,

              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_12),

              itemBuilder: (context, index) => PostCard(post: filtered[index]),
            );
          },

          loading: () => const AppLoading(),

          error: (error, _) => AppError(error: error, onRetry: () => ref.invalidate(feedProvider)),
        ),
      ),
    );
  }
}
