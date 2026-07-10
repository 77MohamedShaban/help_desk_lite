import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../tickets/presentation/cubit/ticket_list_cubit.dart';
import '../../../tickets/presentation/widgets/ticket_list_item.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

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
      child: BlocProvider(
        create: (context) => getIt<TicketListCubit>()..watchAllTickets(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Manager Console'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: Column(
            children: [
              const _StatisticsSection(),
              Expanded(
                child: BlocBuilder<TicketListCubit, TicketListState>(
                  builder: (context, state) {
                    if (state is TicketListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TicketListLoaded) {
                      if (state.tickets.isEmpty) {
                        return const Center(child: Text('No tickets found.'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.tickets.length,
                        itemBuilder: (context, index) {
                          return TicketListItem(ticket: state.tickets[index]);
                        },
                      );
                    } else if (state is TicketListError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketListCubit, TicketListState>(
      builder: (context, state) {
        if (state is TicketListLoaded) {
          final tickets = state.tickets;
          return Container(
            padding: const EdgeInsets.all(16),
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _StatCard(title: 'Total', value: tickets.length.toString(), color: Colors.blue),
                _StatCard(
                  title: 'Open',
                  value: tickets.where((t) => t.status == TicketStatus.newTicket).length.toString(),
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'In Progress',
                  value: tickets.where((t) => t.status == TicketStatus.inProgress).length.toString(),
                  color: Colors.amber,
                ),
                _StatCard(
                  title: 'Resolved',
                  value: tickets.where((t) => t.status == TicketStatus.resolved).length.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}
