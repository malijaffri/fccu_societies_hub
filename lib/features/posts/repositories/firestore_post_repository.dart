import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/models/post.dart';

class FirestorePostRepository implements PostRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Post>> fetchPosts({String? currentUserId}) async {
    final snapshot = await _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    return snapshot.docs
        .map((d) => Post.fromMap(d.data(), currentUserId: currentUserId))
        .toList();
  }

  @override
  Future<List<Post>> fetchFeed({
    String? currentUserId,
    List<String>? followedSocietyIds,
  }) async {
    if (followedSocietyIds == null || followedSocietyIds.isEmpty) {
      return [];
    }

    // Firestore whereIn supports at most 30 values per query
    final chunks = <List<String>>[];
    for (var i = 0; i < followedSocietyIds.length; i += 30) {
      chunks.add(followedSocietyIds.sublist(
        i,
        i + 30 > followedSocietyIds.length ? followedSocietyIds.length : i + 30,
      ));
    }

    final results = await Future.wait(
      chunks.map((chunk) => _db
          .collection('posts')
          .where('societyId', whereIn: chunk)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get()),
    );

    final posts = results
        .expand((s) => s.docs)
        .map((d) => Post.fromMap(d.data(), currentUserId: currentUserId))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return posts;
  }

  @override
  Future<List<Post>> fetchPostsBySociety(String societyId, {String? currentUserId}) async {
    final snapshot = await _db
        .collection('posts')
        .where('societyId', isEqualTo: societyId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();
    return snapshot.docs
        .map((d) => Post.fromMap(d.data(), currentUserId: currentUserId))
        .toList();
  }

  @override
  Future<Post?> getPost(String postId, {String? currentUserId}) async {
    final doc = await _db.collection('posts').doc(postId).get();
    if (!doc.exists) return null;
    return Post.fromMap(doc.data()!, currentUserId: currentUserId);
  }

  @override
  Future<void> createPost(Post post) async {
    final doc = _db.collection('posts').doc();
    await doc.set(post.copyWith(id: doc.id).toMap());
  }

  @override
  Future<void> updatePost(Post post) async =>
      await _db.collection('posts').doc(post.id).set(post.toMap());

  @override
  Future<void> deletePost(String postId) async =>
      await _db.collection('posts').doc(postId).delete();

  @override
  Future<void> likePost(String postId, String userId) async {
    await _db.collection('posts').doc(postId).update({
      'likerIds': FieldValue.arrayUnion([userId]),
      'likeCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    await _db.collection('posts').doc(postId).update({
      'likerIds': FieldValue.arrayRemove([userId]),
      'likeCount': FieldValue.increment(-1),
    });
  }
}
