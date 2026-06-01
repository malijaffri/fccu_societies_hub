import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/models/comment.dart';

class FirestoreCommentRepository implements CommentRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Comment>> fetchComments(String postId) async {
    final snapshot = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((d) => Comment.fromMap(d.data())).toList();
  }

  @override
  Future<void> createComment(Comment comment) async {
    final batch = _db.batch();
    final doc = _db.collection('comments').doc();
    batch.set(doc, comment.copyWith(id: doc.id).toMap());
    batch.update(_db.collection('posts').doc(comment.postId), {
      'commentCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  @override
  Future<void> updateComment(Comment comment) async =>
      await _db.collection('comments').doc(comment.id).set(comment.toMap());

  @override
  Future<void> deleteComment(String commentId) async => await _db.collection('comments').doc(commentId).delete();
}
