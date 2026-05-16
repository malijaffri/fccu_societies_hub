import 'package:fccu_societies_hub/mock/mock_posts.dart';
import 'package:fccu_societies_hub/models/post.dart';

abstract class FeedRepository {
  Future<List<Post>> fetchFeed();
}

class MockFeedRepository implements FeedRepository {
  @override
  Future<List<Post>> fetchFeed() async {
    await Future.delayed(const .new(seconds: 1));

    return mockPosts.where((post) => post.isFollowed).toList();
  }
}
