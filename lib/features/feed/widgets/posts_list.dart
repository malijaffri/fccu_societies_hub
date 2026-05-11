import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/models/post.dart';
import 'package:fccu_societies_hub/features/feed/widgets/post_card.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;

  const PostsList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s_8),
    itemCount: posts.length,
    itemBuilder: (context, index) =>
        PostCard(post: posts[index], onTap: () {}, onLike: () {}, onComment: () {}, onShare: () {}),
  );
}
