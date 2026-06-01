import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/post.dart';

class MockPostRepository implements PostRepository {
  @override
  Future<List<Post>> fetchPosts({String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPosts;
  }

  @override
  Future<List<Post>> fetchFeed({String? currentUserId, List<String>? followedSocietyIds}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPosts.where((p) => p.isFollowed).toList();
  }

  @override
  Future<List<Post>> fetchPostsBySociety(String societyId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPosts.where((p) => p.societyId == societyId).toList();
  }

  @override
  Future<List<Post>> fetchPostsByUser(String authorId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPosts.where((p) => p.authorId == authorId).toList();
  }

  @override
  Future<Post?> getPost(String postId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return mockPosts.firstWhere((p) => p.id == postId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createPost(Post post) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updatePost(Post post) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deletePost(String postId) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> likePost(String postId, String userId, {String? actorName, String? actorAvatarUrl}) async =>
      Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> unlikePost(String postId, String userId) async =>
      Future.delayed(const Duration(milliseconds: 300));
}
