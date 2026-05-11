import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/media.dart';

class PostMediaGrid extends StatelessWidget {
  final List<Media> media;

  const PostMediaGrid({super.key, required this.media});

  @override
  Widget build(BuildContext context) => switch (media.length) {
    0 => const SizedBox.shrink(),
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
    borderRadius: .circular(AppRadius.r_12),
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
            borderRadius: const .only(topLeft: .circular(AppRadius.r_12), bottomLeft: .circular(AppRadius.r_12)),
            height: .infinity,
          ),
        ),

        const SizedBox(width: AppSpacing.s_2),

        Expanded(
          child: _GridImage(
            url: media.$2.url,
            borderRadius: const .only(topRight: .circular(AppRadius.r_12), bottomRight: .circular(AppRadius.r_12)),
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
            borderRadius: const .only(topLeft: .circular(AppRadius.r_12), bottomLeft: .circular(AppRadius.r_12)),
            height: .infinity,
          ),
        ),

        const SizedBox(width: AppSpacing.s_2),

        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _GridImage(
                  url: media.$2.url,
                  borderRadius: const .only(topRight: .circular(AppRadius.r_12)),
                  width: .infinity,
                ),
              ),

              const SizedBox(height: AppSpacing.s_2),

              Expanded(
                child: _GridImage(
                  url: media.$3.url,
                  borderRadius: const .only(bottomRight: .circular(AppRadius.r_12)),
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
                  borderRadius: const .only(topLeft: .circular(AppRadius.r_12)),
                  height: .infinity,
                ),
              ),

              const SizedBox(width: AppSpacing.s_2),

              Expanded(
                child: _GridImage(
                  url: media.$2.url,
                  borderRadius: const .only(topRight: .circular(AppRadius.r_12)),
                  height: .infinity,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.s_2),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _GridImage(
                  url: media.$3.url,
                  borderRadius: const .only(bottomLeft: .circular(AppRadius.r_12)),
                  height: .infinity,
                ),
              ),

              const SizedBox(width: AppSpacing.s_2),

              Expanded(
                child: Stack(
                  fit: .expand,
                  children: [
                    _GridImage(
                      url: media.$4.url,
                      borderRadius: const .only(bottomRight: .circular(AppRadius.r_12)),
                      height: .infinity,
                    ),

                    if (extraMedia.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: const .only(bottomRight: .circular(AppRadius.r_12)),
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
