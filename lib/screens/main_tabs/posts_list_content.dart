import 'package:flutter/material.dart';

import '../../widgets/post_card.dart';

class PostsListContent extends StatelessWidget {
  const PostsListContent({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 3, // TODO: Mock data count
    itemBuilder: (context, index) => PostCard(
      posterName: 'Society Name',
      postedAt: DateTime.now(),
      content: 'Post Description\nWith multiple lines\nAnd potentially rich text.',
      imageUrls: [],
      favorites: 1_000_000,
      comments: 92,
      bookmarks: 1_400,
    ),
  );
}
