import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String commentId;
  final String userId;
  final String userName;
  final String message;
  final DateTime createdAt;

  const CommentEntity({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [commentId, userId, userName, message, createdAt];
}
