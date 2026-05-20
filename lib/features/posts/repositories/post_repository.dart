import 'package:fccu_societies_hub/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts();

  Future<List<Post>> fetchFeed();

  Future<Post?> getPost(String postId);

  Future<void> createPost(Post post);

  Future<void> updatePost(Post post);

  Future<void> deletePost(String postId);
}
