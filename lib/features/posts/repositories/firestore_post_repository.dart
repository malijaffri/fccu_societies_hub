import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/posts/repositories/post_repository.dart';
import 'package:fccu_societies_hub/models/notification_item.dart';
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
    if (followedSocietyIds == null || followedSocietyIds.isEmpty) return [];

    final chunks = <List<String>>[];
    for (var i = 0; i < followedSocietyIds.length; i += 30) {
      final end = (i + 30).clamp(0, followedSocietyIds.length);
      chunks.add(followedSocietyIds.sublist(i, end));
    }

    final results = await Future.wait(
      chunks.map((chunk) => _db
          .collection('posts')
          .where('societyId', whereIn: chunk)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get()),
    );

    return results
        .expand((s) => s.docs)
        .map((d) => Post.fromMap(d.data(), currentUserId: currentUserId))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
  Future<List<Post>> fetchPostsByUser(String authorId, {String? currentUserId}) async {
    final snapshot = await _db
        .collection('posts')
        .where('authorId', isEqualTo: authorId)
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
  Future<String> createPost(Post post) async {
    final doc = _db.collection('posts').doc();
    await doc.set(post.copyWith(id: doc.id).toMap());
    return doc.id;
  }

  @override
  Future<void> updatePost(Post post) async =>
      _db.collection('posts').doc(post.id).set(post.toMap());

  @override
  Future<void> deletePost(String postId) async =>
      _db.collection('posts').doc(postId).delete();

  @override
  Future<void> likePost(
    String postId,
    String userId, {
    String? actorName,
    String? actorAvatarUrl,
  }) async {
    final postDoc = await _db.collection('posts').doc(postId).get();
    if (!postDoc.exists) return;

    final data = postDoc.data()!;
    final authorId = data['authorId'] as String;
    final postContent = data['content'] as String? ?? '';

    final batch = _db.batch();
    batch.update(_db.collection('posts').doc(postId), {
      'likerIds': FieldValue.arrayUnion([userId]),
      'likeCount': FieldValue.increment(1),
    });

    // Notify post author (skip self-likes)
    if (authorId != userId) {
      final notifRef = _db
          .collection('notifications')
          .doc(authorId)
          .collection('items')
          .doc();
      final preview = postContent.length > 80
          ? '${postContent.substring(0, 80)}…'
          : postContent;
      batch.set(notifRef, {
        'id': notifRef.id,
        'type': NotificationType.like.name,
        'actorId': userId,
        'actorName': actorName ?? 'Someone',
        'actorAvatarUrl': actorAvatarUrl,
        'postId': postId,
        'postContent': preview,
        'commentContent': null,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  @override
  Future<void> unlikePost(String postId, String userId) async =>
      _db.collection('posts').doc(postId).update({
        'likerIds': FieldValue.arrayRemove([userId]),
        'likeCount': FieldValue.increment(-1),
      });
}
