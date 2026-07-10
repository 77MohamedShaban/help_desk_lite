import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../cubit/ticket_details_cubit.dart';
import '../widgets/comment_section.dart';

class TicketDetailsPage extends StatelessWidget {
  final String ticketId;

  const TicketDetailsPage({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as Authenticated).user;

    return BlocProvider(
      create: (context) => getIt<TicketDetailsCubit>()..loadTicket(ticketId),
      child: BlocConsumer<TicketDetailsCubit, TicketDetailsState>(
        listener: (context, state) {
          if (state is TicketActionSuccess) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket deleted successfully')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ticket Details'),
              actions: [
                if (state is TicketDetailsLoaded)
                  _buildDeleteAction(context, state.ticket, user),
              ],
            ),
            body: _buildBody(context, state, user),
          );
        },
      ),
    );
  }

  Widget _buildDeleteAction(BuildContext context, dynamic ticket, dynamic user) {
    final bool isOwner = user.uid == ticket.createdBy;
    final bool isManager = user.role == UserRole.manager;

    if (isOwner || isManager) {
      return IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => _showDeleteDialog(context, ticket.ticketId),
      );
    }
    return const SizedBox.shrink();
  }

  void _showDeleteDialog(BuildContext context, String ticketId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: const Text('Are you sure you want to delete this ticket? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TicketDetailsCubit>().deleteTicket(ticketId);
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, TicketDetailsState state, dynamic user) {
    if (state is TicketDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TicketDetailsLoaded) {
      final ticket = state.ticket;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${ticket.ticketId.substring(0, (ticket.ticketId.length > 8 ? 8 : ticket.ticketId.length))}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text(DateFormat('MMM dd, yyyy HH:mm').format(ticket.createdAt)),
              ],
            ),
            const SizedBox(height: 16),
            Text(ticket.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                _DetailBadge(label: ticket.category.name.toUpperCase(), color: Colors.blueGrey),
                const SizedBox(width: 8),
                _DetailBadge(label: ticket.status.name.toUpperCase(), color: Colors.blue),
                const SizedBox(width: 8),
                _DetailBadge(label: ticket.priority.name.toUpperCase(), color: _getPriorityColor(ticket.priority)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(ticket.description),
            const SizedBox(height: 32),
            if (user.role != UserRole.employee) ...[
              _AgentActions(ticket: ticket),
              const SizedBox(height: 32),
            ],
            const Divider(),
            const SizedBox(height: 16),
            CommentSection(ticketId: ticket.ticketId),
          ],
        ),
      );
    } else if (state is TicketError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox();
  }

  Color _getPriorityColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return Colors.green;
      case TicketPriority.medium:
        return Colors.blue;
      case TicketPriority.high:
        return Colors.orange;
      case TicketPriority.urgent:
        return Colors.red;
    }
  }
}

class _DetailBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DetailBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _AgentActions extends StatelessWidget {
  final dynamic ticket;
  const _AgentActions({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Manage Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            if (ticket.status == TicketStatus.newTicket)
              ActionChip(
                label: const Text('Assign to Me'),
                onPressed: () {
                  final user = (context.read<AuthCubit>().state as Authenticated).user;
                  context.read<TicketDetailsCubit>().assign(ticket.ticketId, user.uid);
                },
              ),
            if (ticket.status == TicketStatus.assigned)
              ActionChip(
                label: const Text('Start Work'),
                onPressed: () => context.read<TicketDetailsCubit>().updateStatus(ticket.ticketId, TicketStatus.inProgress),
              ),
            if (ticket.status == TicketStatus.inProgress)
              ActionChip(
                label: const Text('Resolve'),
                onPressed: () => context.read<TicketDetailsCubit>().updateStatus(ticket.ticketId, TicketStatus.resolved),
              ),
            if (ticket.status == TicketStatus.resolved)
              ActionChip(
                label: const Text('Close'),
                onPressed: () => context.read<TicketDetailsCubit>().updateStatus(ticket.ticketId, TicketStatus.closed),
              ),
          ],
        ),
      ],
    );
  }
}
