import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/posts/repositories/firestore_post_repository.dart';
import 'package:fccu_societies_hub/features/posts/repositories/mock_post_repository.dart';
import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/models/post.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => FirestorePostRepository());
// final postRepositoryProvider = Provider<PostRepository>((ref) => MockPostRepository());

final feedProvider = FutureProvider<List<Post>>((ref) async => ref.watch(postRepositoryProvider).fetchFeed());

final postsProvider = FutureProvider<List<Post>>((ref) async => ref.watch(postRepositoryProvider).fetchPosts());

final postProvider = FutureProvider.family<Post?, String>(
  (ref, postId) async => ref.watch(postRepositoryProvider).getPost(postId),
);
