import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/posts/repositories/firestore_post_repository.dart';
import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/features/societies/providers/societies_provider.dart';
import 'package:fccu_societies_hub/models/post.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => FirestorePostRepository());

final feedProvider = FutureProvider<List<Post>>((ref) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;

  // Watch the AsyncValue synchronously to avoid the Riverpod 3 assertion triggered
  // by mixing `await` with `ref.watch(provider.future)` (double-subscription bug).
  // feedProvider re-runs automatically when societiesProvider emits a new value.
  final societies = ref.watch(societiesProvider).asData?.value ?? [];
  final followedIds = societies
      .where((s) => s.isFollowed)
      .map((s) => s.id)
      .toList();

  return ref.read(postRepositoryProvider).fetchFeed(
    currentUserId: currentUserId,
    followedSocietyIds: followedIds,
  );
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(postRepositoryProvider).fetchPosts(currentUserId: currentUserId);
});

final postProvider = FutureProvider.family<Post?, String>((ref, postId) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(postRepositoryProvider).getPost(postId, currentUserId: currentUserId);
});

final societyPostsProvider = FutureProvider.family<List<Post>, String>((ref, societyId) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(postRepositoryProvider).fetchPostsBySociety(societyId, currentUserId: currentUserId);
});

final userPostsProvider = FutureProvider.family<List<Post>, String>((ref, authorId) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(postRepositoryProvider).fetchPostsByUser(authorId, currentUserId: currentUserId);
});
