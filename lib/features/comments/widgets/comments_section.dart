import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/comments/providers/comments_provider.dart';
import 'package:fccu_societies_hub/features/comments/widgets/comment_tile.dart';
import 'package:fccu_societies_hub/models/comment.dart';

class CommentsSection extends ConsumerWidget {
  final String postId;

  final AsyncValue<List<Comment>> commentsAsync;

  const CommentsSection({super.key, required this.postId, required this.commentsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) => commentsAsync.when(
    data: (comments) {
      if (comments.isEmpty) {
        return const Padding(
          padding: .all(AppSpacing.s_24),

          child: EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'No comments yet',
            subtitle: 'Start the conversation.',
          ),
        );
      }

      return Column(children: comments.map((comment) => CommentTile(comment: comment)).toList());
    },

    loading: () => const Padding(padding: .symmetric(vertical: 32), child: AppLoading()),

    error: (error, _) => Padding(
      padding: const .all(AppSpacing.s_16),
      child: AppError(error: error, onRetry: () => ref.invalidate(commentsProvider(postId))),
    ),
  );
}
