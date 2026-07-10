import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../tickets/presentation/cubit/ticket_list_cubit.dart';
import '../../../tickets/presentation/widgets/ticket_list_item.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = authState.user;

          return BlocProvider(
            create: (context) => getIt<TicketListCubit>()..watchUserTickets(user.uid),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('My Tickets'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
              body: BlocBuilder<TicketListCubit, TicketListState>(
                builder: (context, ticketState) {
                  if (ticketState is TicketListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (ticketState is TicketListLoaded) {
                    if (ticketState.tickets.isEmpty) {
                      return const Center(child: Text('No tickets yet. Create one!'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ticketState.tickets.length,
                      itemBuilder: (context, index) {
                        return TicketListItem(ticket: ticketState.tickets[index]);
                      },
                    );
                  } else if (ticketState is TicketListError) {
                    return Center(child: Text(ticketState.message));
                  }
                  return const SizedBox();
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => context.push('/create-ticket'),
                label: const Text('New Ticket'),
                icon: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}
