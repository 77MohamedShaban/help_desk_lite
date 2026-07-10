import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/error_message_handler.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';

part 'comment_state.dart';

@injectable
class CommentCubit extends Cubit<CommentState> {
  final CommentRepository _commentRepository;

  CommentCubit(this._commentRepository) : super(CommentInitial());

  void watchComments(String ticketId) {
    emit(CommentLoading());
    _commentRepository.watchComments(ticketId).listen(
      (comments) => emit(CommentLoaded(comments)),
      onError: (e) => emit(CommentError(ErrorMessageHandler.map(e))),
    );
  }

  Future<void> addComment(String ticketId, CommentEntity comment) async {
    try {
      await _commentRepository.addComment(ticketId, comment);
    } catch (e) {
      emit(CommentError(ErrorMessageHandler.map(e)));
    }
  }
}
