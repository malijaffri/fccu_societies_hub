import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_card.dart';
import 'package:fccu_societies_hub/models/post.dart';
import 'package:fccu_societies_hub/widgets/items_list.dart';

class PostsList extends ItemsList<Post> {
  static const noItemsYet = 'No posts yet';
  static const noItemsFound = 'No posts found';
  static const noItemsLong = 'Posts from societies will appear here.';

  final FutureProvider<List<Post>> postsProviderActual;

  PostsList({super.key, FutureProvider<List<Post>>? postsProviderActual, super.filter, super.userFilter, super.failMsg})
    : postsProviderActual = postsProviderActual ?? postsProvider;

  @override
  IconData get icon => Icons.forum_outlined;

  @override
  Widget itemCard(Post item) => PostCard(post: item);

  @override
  FutureProvider<List<Post>> get itemsProvider => postsProviderActual;
}
