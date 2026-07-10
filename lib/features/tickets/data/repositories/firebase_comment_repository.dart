import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../models/comment_model.dart';

@LazySingleton(as: CommentRepository)
class FirebaseCommentRepository implements CommentRepository {
  final FirebaseFirestore _firestore;

  FirebaseCommentRepository(this._firestore);

  @override
  Future<void> addComment(String ticketId, CommentEntity comment) async {
    final model = CommentModel(
      commentId: '',
      userId: comment.userId,
      userName: comment.userName,
      message: comment.message,
      createdAt: comment.createdAt,
    );

    await _firestore
        .collection(AppConstants.ticketsCollection)
        .doc(ticketId)
        .collection(AppConstants.commentsCollection)
        .add(model.toFirestore());
    
    await _firestore.collection(AppConstants.ticketsCollection).doc(ticketId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<CommentEntity>> getComments(String ticketId) async {
    final snapshot = await _firestore
        .collection(AppConstants.ticketsCollection)
        .doc(ticketId)
        .collection(AppConstants.commentsCollection)
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => CommentModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Stream<List<CommentEntity>> watchComments(String ticketId) {
    return _firestore
        .collection(AppConstants.ticketsCollection)
        .doc(ticketId)
        .collection(AppConstants.commentsCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
