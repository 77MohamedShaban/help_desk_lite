import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/comment_entity.dart';
import '../cubit/comment_cubit.dart';

class CommentSection extends StatelessWidget {
  final String ticketId;

  const CommentSection({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CommentCubit>()..watchComments(ticketId),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CommentLoaded) {
                if (state.comments.isEmpty) {
                  return const Text('No comments yet.');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];
                    return _CommentItem(comment: comment);
                  },
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 16),
          _AddCommentField(ticketId: ticketId),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(
                DateFormat('MMM dd, HH:mm').format(comment.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment.message),
          const Divider(),
        ],
      ),
    );
  }
}

class _AddCommentField extends StatefulWidget {
  final String ticketId;
  const _AddCommentField({required this.ticketId});

  @override
  State<_AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<_AddCommentField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Add a comment...'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              final user = (context.read<AuthCubit>().state as Authenticated).user;
              context.read<CommentCubit>().addComment(
                    widget.ticketId,
                    CommentEntity(
                      commentId: '',
                      userId: user.uid,
                      userName: user.name,
                      message: _controller.text,
                      createdAt: DateTime.now(),
                    ),
                  );
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
