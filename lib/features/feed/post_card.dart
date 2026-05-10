import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fccu_societies_hub/models/media.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({super.key, required this.post, this.onTap, this.onLike, this.onComment, this.onShare});

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
                crossAxisAlignment: .start,
                children: [
                  _PostHeader(post: post),

                  const SizedBox(height: 12),

                  SelectableText(
                    post.content,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.42, fontSize: 15.5),
                  ),

                  if (post.media.isNotEmpty) ...[const SizedBox(height: 12), _PostMediaGrid(media: post.media)],

                  const SizedBox(height: 14),

                  _PostActions(post: post, onLike: onLike, onComment: onComment, onShare: onShare),
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
      crossAxisAlignment: .start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.secondaryContainer,
          backgroundImage: post.societyImage != null ? NetworkImage(post.societyImage!) : null,
          child: post.societyImage == null
              ? Text(
                  post.societyName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join().toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: .w700,
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
              crossAxisAlignment: .start,
              children: [
                Text(post.societyName, style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, fontWeight: .w600)),

                const SizedBox(height: 2),

                Text(
                  _formatTimestamp(post.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),

        IconButton(onPressed: () {}, visualDensity: .compact, icon: const Icon(Icons.more_horiz_rounded)),
      ],
    );
  }
}

class _PostMediaGrid extends StatelessWidget {
  final List<Media> media;

  const _PostMediaGrid({required this.media});

  @override
  Widget build(BuildContext context) => switch (media.length) {
    1 => _SingleImage(media: media.first),
    2 => _TwoImageGrid(media: (media[0], media[1])),
    3 => _ThreeImageGrid(media: (media[0], media[1], media[2])),
    _ => _FourImageGrid(media: (media[0], media[1], media[2], media[3]), extraMedia: media.skip(4).toList()),
  };
}

class _SingleImage extends StatelessWidget {
  final Media media;

  const _SingleImage({required this.media});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: AspectRatio(
      aspectRatio: 16 / 10,
      child: Image.network(media.url, fit: .cover),
    ),
  );
}

class _TwoImageGrid extends StatelessWidget {
  final (Media, Media) media;

  const _TwoImageGrid({required this.media});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 10,
    child: Row(
      children: [
        Expanded(
          child: _GridImage(
            url: media.$1.url,
            borderRadius: const .only(topLeft: .circular(12), bottomLeft: .circular(12)),
            height: .infinity,
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
          child: _GridImage(
            url: media.$2.url,
            borderRadius: const .only(topRight: .circular(12), bottomRight: .circular(12)),
            height: .infinity,
          ),
        ),
      ],
    ),
  );
}

class _ThreeImageGrid extends StatelessWidget {
  final (Media, Media, Media) media;

  const _ThreeImageGrid({required this.media});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 10,
    child: Row(
      children: [
        Expanded(
          child: _GridImage(
            url: media.$1.url,
            borderRadius: const .only(topLeft: .circular(12), bottomLeft: .circular(12)),
            height: .infinity,
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _GridImage(
                  url: media.$2.url,
                  borderRadius: const .only(topRight: .circular(12)),
                  width: .infinity,
                ),
              ),

              const SizedBox(height: 2),

              Expanded(
                child: _GridImage(
                  url: media.$3.url,
                  borderRadius: const .only(bottomRight: .circular(12)),
                  width: .infinity,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FourImageGrid extends StatelessWidget {
  final (Media, Media, Media, Media) media;
  final List<Media> extraMedia;

  const _FourImageGrid({required this.media, this.extraMedia = const []});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 10,
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _GridImage(
                  url: media.$1.url,
                  borderRadius: const .only(topLeft: .circular(12)),
                  height: .infinity,
                ),
              ),

              const SizedBox(width: 2),

              Expanded(
                child: _GridImage(
                  url: media.$2.url,
                  borderRadius: const .only(topRight: .circular(12)),
                  height: .infinity,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _GridImage(
                  url: media.$3.url,
                  borderRadius: const .only(bottomLeft: .circular(12)),
                  height: .infinity,
                ),
              ),

              const SizedBox(width: 2),

              Expanded(
                child: Stack(
                  fit: .expand,
                  children: [
                    _GridImage(
                      url: media.$4.url,
                      borderRadius: const .only(bottomRight: .circular(12)),
                      height: .infinity,
                    ),

                    if (extraMedia.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: const .only(bottomRight: .circular(12)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+${extraMedia.length + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: .w700),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _GridImage extends StatelessWidget {
  final String url;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  const _GridImage({required this.url, required this.borderRadius, this.width, this.height});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: Image.network(url, fit: .cover, width: width, height: height),
  );
}

class _PostActions extends StatelessWidget {
  final Post post;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const _PostActions({required this.post, this.onLike, this.onComment, this.onShare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _ActionButton(
          icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: post.isLiked ? Colors.red : colorScheme.onSurfaceVariant,
          label: _formatNumber(post.likeCount),
          onTap: onLike,
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.mode_comment_outlined,
          color: colorScheme.onSurfaceVariant,
          label: _formatNumber(post.commentCount),
          onTap: onComment,
        ),

        const SizedBox(width: 20),

        _ActionButton(icon: Icons.share_outlined, color: colorScheme.onSurfaceVariant, onTap: onShare),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? label;

  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.color, this.label, this.onTap});

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

            if (label != null) ...[
              const SizedBox(width: 6),

              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: .w500),
              ),
            ],
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
