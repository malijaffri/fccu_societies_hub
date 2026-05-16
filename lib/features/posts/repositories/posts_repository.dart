import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/post.dart';

abstract class PostsRepository {
  Future<List<Post>> fetchPosts();

  Future<Post> fetchPost(String postId);
}

class MockPostsRepository implements PostsRepository {
  @override
  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const .new(seconds: 1));

    return mockPosts;
  }

  @override
  Future<Post> fetchPost(String postId) async {
    await Future.delayed(const .new(seconds: 1));

    return mockPosts.firstWhere((post) => post.id == postId);
  }
}
