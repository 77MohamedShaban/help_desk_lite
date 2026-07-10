import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class TicketEntity extends Equatable {
  final String ticketId;
  final String title;
  final String description;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final String createdBy;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TicketEntity({
    required this.ticketId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdBy,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        ticketId,
        title,
        description,
        category,
        priority,
        status,
        createdBy,
        assignedTo,
        createdAt,
        updatedAt,
      ];
}
