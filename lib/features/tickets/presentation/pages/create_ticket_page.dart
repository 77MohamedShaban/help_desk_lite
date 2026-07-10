import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/ticket_entity.dart';
import '../cubit/ticket_details_cubit.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TicketCategory _category = TicketCategory.general;
  TicketPriority _priority = TicketPriority.medium;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TicketDetailsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('New Ticket')),
        body: BlocListener<TicketDetailsCubit, TicketDetailsState>(
          listener: (context, state) {
            if (state is TicketActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket created successfully')),
              );
              context.pop();
            } else if (state is TicketError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 4,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TicketCategory>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: TicketCategory.values.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()));
                    }).toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TicketPriority>(
                    value: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: TicketPriority.values.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()));
                    }).toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                  const SizedBox(height: 32),
                  Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final user = (context.read<AuthCubit>().state as Authenticated).user;
                          context.read<TicketDetailsCubit>().createTicket(
                                TicketEntity(
                                  ticketId: '',
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  category: _category,
                                  priority: _priority,
                                  status: TicketStatus.newTicket,
                                  createdBy: user.uid,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        }
                      },
                      child: const Text('Submit Ticket'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
