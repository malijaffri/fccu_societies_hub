import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/post/widgets/post_card.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;

  const PostsList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s_8),
    itemCount: posts.length,
    itemBuilder: (context, index) {
      final post = posts[index];

      return PostCard(post: post);
    },
  );
}
