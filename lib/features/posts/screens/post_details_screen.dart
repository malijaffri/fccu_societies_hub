import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/comments/providers/comments_provider.dart';
import 'package:fccu_societies_hub/features/comments/widgets/comment_composer.dart';
import 'package:fccu_societies_hub/features/comments/widgets/comments_section.dart';
import 'package:fccu_societies_hub/features/comments/widgets/guest_comment_prompt.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_card.dart';
import 'package:fccu_societies_hub/features/session/providers/session_permissions_provider.dart';

class PostDetailsScreen extends ConsumerWidget {
  final String postId;

  const PostDetailsScreen({super.key, required this.postId});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(postProvider(postId));
    ref.invalidate(commentsProvider(postId));

    await Future.wait([ref.read(postProvider(postId).future), ref.read(commentsProvider(postId).future)]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canComment = ref.watch(canCommentProvider);

    final postAsync = ref.watch(postProvider(postId));
    final commentsAsync = ref.watch(commentsProvider(postId));

    if (postAsync.isLoading) {
      return const Scaffold(body: AppLoading());
    }

    if (postAsync.hasError) {
      return Scaffold(
        body: AppError(error: postAsync.error!, onRetry: () => ref.invalidate(postProvider(postId))),
      );
    }

    final post = postAsync.value;
    if (post == null) {
      return Scaffold(
        body: AppError(error: 'Post not found', onRetry: () => ref.invalidate(postProvider(postId))),
      );
    }

    return Scaffold(
      appBar: AppBar(),

      resizeToAvoidBottomInset: true,

      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),

        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s_8, bottom: AppSpacing.s_12),

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s_12, vertical: AppSpacing.s_8),
                    child: PostCard(post: post, compact: false),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s_16,
                      AppSpacing.s_12,
                      AppSpacing.s_16,
                      AppSpacing.s_8,
                    ),

                    child: Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                  ),

                  CommentsSection(postId: postId, commentsAsync: commentsAsync),
                ],
              ),
            ),

            SafeArea(top: false, child: canComment ? CommentComposer(postId: postId) : const GuestCommentPrompt()),
          ],
        ),
      ),
    );
  }
}
