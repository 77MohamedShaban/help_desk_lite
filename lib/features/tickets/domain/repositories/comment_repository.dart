import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getComments(String ticketId);
  Future<void> addComment(String ticketId, CommentEntity comment);
  Stream<List<CommentEntity>> watchComments(String ticketId);
}
