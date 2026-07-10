import '../entities/ticket_entity.dart';
import '../../../../core/constants/app_constants.dart';

abstract class TicketRepository {
  Future<List<TicketEntity>> getTickets({
    UserRole? role,
    String? userId,
    TicketStatus? status,
    TicketCategory? category,
    TicketPriority? priority,
  });
  
  Future<TicketEntity> getTicketById(String ticketId);
  
  Future<void> createTicket(TicketEntity ticket);
  
  Future<void> updateTicketStatus(String ticketId, TicketStatus status);
  
  Future<void> assignTicket(String ticketId, String agentId);
  
  Future<void> deleteTicket(String ticketId);
  
  Stream<List<TicketEntity>> watchTickets({
    UserRole? role,
    String? userId,
    String? category,
  });
}
