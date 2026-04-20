import 'package:flutter/material.dart';

class MediaGallery extends StatelessWidget {
  const MediaGallery({super.key, required this.images});

  final List<String> images;
  final double gap = 2.0;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildGalleryGrid()),
    );
  }

  Widget _buildGalleryGrid() {
    switch (images.length) {
      case 1:
        return _imageItem(images[0]);
      case 2:
        return Row(
          children: [
            Expanded(child: _imageItem(images[0])),
            SizedBox(width: gap),
            Expanded(child: _imageItem(images[1])),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(child: _imageItem(images[0])),
            SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _imageItem(images[1])),
                  SizedBox(height: gap),
                  Expanded(child: _imageItem(images[2])),
                ],
              ),
            ),
          ],
        );
      default: // 4 or more
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _imageItem(images[0])),
                  SizedBox(width: gap),
                  Expanded(child: _imageItem(images[1])),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _imageItem(images[2])),
                  SizedBox(width: gap),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _imageItem(images[3]),
                        if (images.length > 4)
                          Container(
                            color: Colors.black45,
                            child: Center(
                              child: Text(
                                '+${images.length - 4}',
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _imageItem(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
    );
  }
}
