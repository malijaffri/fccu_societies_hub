import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/posts/repositories/firestore_post_repository.dart';
import 'package:fccu_societies_hub/features/posts/repositories/mock_post_repository.dart';
import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/models/post.dart';

// final postsRepositoryProvider = Provider<PostRepository>((ref) => FirestorePostRepository());
final postsRepositoryProvider = Provider<PostRepository>((ref) => MockPostRepository());

final feedProvider = FutureProvider<List<Post>>((ref) async => ref.watch(postsRepositoryProvider).fetchFeed());

final postsProvider = FutureProvider<List<Post>>((ref) async => ref.watch(postsRepositoryProvider).fetchPosts());

final postProvider = FutureProvider.family<Post?, String>(
  (ref, postId) async => ref.watch(postsRepositoryProvider).getPost(postId),
);
