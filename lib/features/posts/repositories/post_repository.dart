import 'package:fccu_societies_hub/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts({String? currentUserId});

  Future<List<Post>> fetchFeed({String? currentUserId, List<String>? followedSocietyIds});

  Future<List<Post>> fetchPostsBySociety(String societyId, {String? currentUserId});

  Future<List<Post>> fetchPostsByUser(String authorId, {String? currentUserId});

  Future<Post?> getPost(String postId, {String? currentUserId});

  Future<void> createPost(Post post);

  Future<void> updatePost(Post post);

  Future<void> deletePost(String postId);

  Future<void> likePost(
    String postId,
    String userId, {
    String? actorName,
    String? actorAvatarUrl,
  });

  Future<void> unlikePost(String postId, String userId);
}
