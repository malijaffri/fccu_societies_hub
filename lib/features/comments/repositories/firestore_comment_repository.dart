import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/models/comment.dart';
import 'package:fccu_societies_hub/models/notification_item.dart';

class FirestoreCommentRepository implements CommentRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Comment>> fetchComments(String postId) async {
    final snapshot = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .limit(50)
        .get();
    return snapshot.docs.map((d) => Comment.fromMap(d.data())).toList();
  }

  @override
  Future<void> createComment(Comment comment) async {
    // Fetch post to get author info for notification
    final postDoc = await _db.collection('posts').doc(comment.postId).get();
    if (!postDoc.exists) return;

    final data = postDoc.data()!;
    final authorId = data['authorId'] as String;
    final postContent = data['content'] as String? ?? '';
    final preview =
        postContent.length > 80 ? '${postContent.substring(0, 80)}…' : postContent;

    final batch = _db.batch();

    // Create comment
    final doc = _db.collection('comments').doc();
    batch.set(doc, comment.copyWith(id: doc.id).toMap());

    // Increment comment count on post
    batch.update(_db.collection('posts').doc(comment.postId), {
      'commentCount': FieldValue.increment(1),
    });

    // Notify post author (skip self-comments)
    if (authorId != comment.userId) {
      final notifRef = _db
          .collection('notifications')
          .doc(authorId)
          .collection('items')
          .doc();
      batch.set(notifRef, {
        'id': notifRef.id,
        'type': NotificationType.comment.name,
        'actorId': comment.userId,
        'actorName': comment.userName,
        'actorAvatarUrl': comment.userAvatar,
        'postId': comment.postId,
        'postContent': preview,
        'commentContent': comment.content,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  @override
  Future<void> updateComment(Comment comment) async =>
      _db.collection('comments').doc(comment.id).set(comment.toMap());

  @override
  Future<void> deleteComment(String commentId) async =>
      _db.collection('comments').doc(commentId).delete();
}
