import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/post.dart';

abstract class PostRepository {
  Future<Post> fetchPost(String id);
}

class MockPostRepository implements PostRepository {
  @override
  Future<Post> fetchPost(String id) async {
    await Future.delayed(const .new(seconds: 1));

    return mockPosts.firstWhere((post) => post.id == id);
  }
}
