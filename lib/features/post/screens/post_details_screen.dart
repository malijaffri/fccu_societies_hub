import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/comments/widgets/comment_composer.dart';
import 'package:fccu_societies_hub/features/comments/widgets/comment_tile.dart';
import 'package:fccu_societies_hub/features/post/widgets/post_card.dart';
import 'package:fccu_societies_hub/mock/mock_comments.dart';
import 'package:fccu_societies_hub/mock/mock_posts.dart';

class PostDetailsScreen extends StatelessWidget {
  final String postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final post = mockPosts.firstWhere((post) => post.id == postId);

    final comments = mockComments.where((comment) => comment.postId == postId).toList();

    return Scaffold(
      appBar: AppBar(),

      resizeToAvoidBottomInset: true,

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const .only(top: AppSpacing.s_8, bottom: AppSpacing.s_12),

              children: [
                PostCard(post: post, compact: false),

                Padding(
                  padding: const .fromLTRB(AppSpacing.s_16, AppSpacing.s_12, AppSpacing.s_16, AppSpacing.s_8),

                  child: Text('Comments', style: textTheme.titleMedium),
                ),

                if (comments.isEmpty)
                  Padding(
                    padding: const .all(AppSpacing.s_16),

                    child: Text(
                      'No comments yet.',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),

                ...comments.map((comment) => CommentTile(comment: comment)),
              ],
            ),
          ),

          const SafeArea(top: false, child: CommentComposer()),
        ],
      ),
    );
  }
}
