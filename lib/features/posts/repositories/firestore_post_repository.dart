import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/models/post.dart';

class FirestorePostRepository implements PostRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Post>> fetchPosts() async {
    final snapshot = await _db.collection('posts').orderBy('createdAt', descending: true).limit(20).get();

    return snapshot.docs.map((d) => Post.fromMap(d.data())).toList();
  }

  @override
  Future<List<Post>> fetchFeed() async {
    final snapshot = await _db.collection('posts').orderBy('createdAt', descending: true).limit(20).get();

    return snapshot.docs.map((d) => Post.fromMap(d.data())).toList();
  }

  @override
  Future<Post?> getPost(String postId) async {
    final doc = await _db.collection('posts').doc(postId).get();

    if (!doc.exists) {
      return null;
    }

    return Post.fromMap(doc.data()!);
  }

  @override
  Future<void> createPost(Post post) async => await _db.collection('posts').doc(post.id).set(post.toMap());

  @override
  Future<void> updatePost(Post post) async => await _db.collection('posts').doc(post.id).set(post.toMap());

  @override
  Future<void> deletePost(String postId) async => await _db.collection('posts').doc(postId).delete();
}
