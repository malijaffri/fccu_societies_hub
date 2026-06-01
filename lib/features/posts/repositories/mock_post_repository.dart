import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/post.dart';

class MockPostRepository implements PostRepository {
  @override
  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 1));

    return mockPosts;
  }

  @override
  Future<List<Post>> fetchFeed() async {
    await Future.delayed(const Duration(seconds: 1));

    return mockPosts.where((post) => post.isFollowed).toList();
  }

  @override
  Future<Post?> getPost(String postId) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      return mockPosts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createPost(Post post) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updatePost(Post post) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deletePost(String postId) async => await Future.delayed(const Duration(seconds: 1));
}
