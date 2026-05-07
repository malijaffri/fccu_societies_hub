import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fccu_societies_hub/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const PostCard({super.key, required this.post, this.onTap, this.onLike, this.onComment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: theme.brightness == Brightness.dark
                ? Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4))
                : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PostHeader(post: post),

                  const SizedBox(height: 12),

                  SelectableText(
                    post.content,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.42, fontSize: 15.5),
                  ),

                  const SizedBox(height: 14),

                  _PostActions(post: post, onLike: onLike, onComment: onComment),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.secondaryContainer,
          backgroundImage: post.societyImage != null ? NetworkImage(post.societyImage!) : null,
          child: post.societyImage == null
              ? Text(
                  post.societyName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join().toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondaryContainer,
                  ),
                )
              : null,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.societyName,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 2),

                Text(
                  _formatTimestamp(post.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),

        IconButton(onPressed: () {}, visualDensity: VisualDensity.compact, icon: const Icon(Icons.more_horiz_rounded)),
      ],
    );
  }
}

class _PostActions extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const _PostActions({required this.post, this.onLike, this.onComment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _ActionButton(
          icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: _formatNumber(post.likeCount),
          color: post.isLiked ? Colors.red : colorScheme.onSurfaceVariant,
          onTap: onLike,
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.mode_comment_outlined,
          label: _formatNumber(post.commentCount),
          color: colorScheme.onSurfaceVariant,
          onTap: onComment,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),

            const SizedBox(width: 6),

            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTimestamp(DateTime time) {
  final difference = DateTime.now().difference(time);

  if (difference.inSeconds < 10) {
    return 'Just now';
  }

  if (difference.inMinutes < 1) {
    return '${difference.inSeconds}s ago';
  }

  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }

  if (difference.inDays < 1) {
    return '${difference.inHours}h ago';
  }

  if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  }

  return DateFormat.yMMMd().format(time);
}

String _formatNumber(int number) {
  if (number < 1000) return number.toString();

  return NumberFormat.compact().format(number);
}
