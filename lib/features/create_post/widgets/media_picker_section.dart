import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class MediaPickerSection extends StatelessWidget {
  final List<File> selectedImages;

  final VoidCallback onAddImages;

  final ValueChanged<File> onRemoveImage;

  const MediaPickerSection({
    super.key,
    required this.selectedImages,
    required this.onAddImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('Images', style: theme.textTheme.titleMedium),

            Text('${selectedImages.length}/4', style: theme.textTheme.bodyMedium),
          ],
        ),

        const SizedBox(height: AppSpacing.s_12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedImages.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.s_12,
            mainAxisSpacing: AppSpacing.s_12,
          ),
          itemBuilder: (context, index) {
            if (index == selectedImages.length) {
              return _AddMediaTile(enabled: selectedImages.length < 4, onTap: onAddImages);
            }

            final image = selectedImages[index];

            return _SelectedImageTile(image: image, onRemove: () => onRemoveImage(image));
          },
        ),
      ],
    );
  }
}

class _AddMediaTile extends StatelessWidget {
  final bool enabled;

  final VoidCallback onTap;

  const _AddMediaTile({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.secondaryContainer.withValues(alpha: 0.45),
      borderRadius: .circular(AppRadius.r_16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: .circular(AppRadius.r_16),
        child: Center(
          child: Icon(Icons.add_photo_alternate_rounded, size: 34, color: colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}

class _SelectedImageTile extends StatelessWidget {
  final File image;

  final VoidCallback onRemove;

  const _SelectedImageTile({required this.image, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(AppRadius.r_16),

      child: Stack(
        fit: .expand,
        children: [
          Image.file(image, fit: .cover),

          Positioned(
            top: AppSpacing.s_8,
            right: AppSpacing.s_8,
            child: IconButton.filledTonal(
              onPressed: onRemove,
              style: IconButton.styleFrom(minimumSize: const .new(36, 36), padding: .zero),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
