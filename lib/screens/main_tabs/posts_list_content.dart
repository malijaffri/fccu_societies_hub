import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/feed/post_card.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostsListContent extends StatelessWidget {
  const PostsListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = mockPosts();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) => PostCard(post: posts[index], onTap: () {}, onLike: () {}, onComment: () {}),
    );
  }
}
