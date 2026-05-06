import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'media_gallery.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.posterName,
    required this.postedAt,
    required this.content,
    required this.imageUrls,
    required this.favorites,
    required this.comments,
    required this.bookmarks,
  });

  final String posterName;
  final DateTime postedAt;
  final String content;
  final List<String> imageUrls;
  final int favorites;
  final int comments;
  final int bookmarks;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Avatar, Poster, Date)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(posterName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Text(
                DateFormat('d MMM yyyy').format(postedAt),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Body (Title, Description)
        Padding(padding: const EdgeInsets.all(16), child: Text(content)),
        if (imageUrls.isNotEmpty) MediaGallery(images: imageUrls),

        const Divider(height: 1),

        // Footer (Actions)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                  Text(_formatNumber(favorites)),
                ],
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
                  Text(_formatNumber(comments)),
                ],
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
                  Text(_formatNumber(bookmarks)),
                ],
              ),
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            ],
          ),
        ),
      ],
    ),
  );

  String _formatNumber(int number) {
    if (number < 1000) return number.toString();

    return NumberFormat.compact().format(number);
  }
}
