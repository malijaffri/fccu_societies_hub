import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/features/comments/providers/comments_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/models/comment.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class CommentComposer extends ConsumerStatefulWidget {
  final String? postId;

  const CommentComposer({super.key, this.postId});

  @override
  ConsumerState<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends ConsumerState<CommentComposer> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty || widget.postId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(currentUserModelProvider).value;
      if (user == null) return;

      final comment = Comment(
        id: DateTime.now().toString(),
        postId: widget.postId!,
        userId: user.id,
        userName: user.name,
        userAvatarUrl: user.avatarUrl,
        text: _controller.text,
        createdAt: DateTime.now(),
      );

      await ref.read(commentRepositoryProvider).createComment(comment);

      if (mounted) {
        _controller.clear();
        ref.invalidate(commentsProvider(widget.postId!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error posting comment: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.s_12, AppSpacing.s_8, AppSpacing.s_12, AppSpacing.s_12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Avatar(),
          const SizedBox(width: AppSpacing.s_12),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_isSubmitting,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                isDense: true,
                contentPadding: const EdgeInsets.all(AppSpacing.s_12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r_24)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s_8),
          IconButton.filled(
            onPressed: _isSubmitting ? null : _submitComment,
            icon: _isSubmitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
