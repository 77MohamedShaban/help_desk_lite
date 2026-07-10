import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../models/ticket_model.dart';

@LazySingleton(as: TicketRepository)
class FirebaseTicketRepository implements TicketRepository {
  final FirebaseFirestore _firestore;

  FirebaseTicketRepository(this._firestore);

  @override
  Future<void> createTicket(TicketEntity ticket) async {
    final model = TicketModel(
      ticketId: '',
      title: ticket.title,
      description: ticket.description,
      category: ticket.category,
      priority: ticket.priority,
      status: ticket.status,
      createdBy: ticket.createdBy,
      createdAt: ticket.createdAt,
      updatedAt: ticket.updatedAt,
    );
    
    await _firestore.collection(AppConstants.ticketsCollection).add(model.toFirestore());
  }

  @override
  Future<TicketEntity> getTicketById(String ticketId) async {
    final doc = await _firestore.collection(AppConstants.ticketsCollection).doc(ticketId).get();
    return TicketModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<List<TicketEntity>> getTickets({
    UserRole? role,
    String? userId,
    TicketStatus? status,
    TicketCategory? category,
    TicketPriority? priority,
  }) async {
    Query query = _firestore.collection(AppConstants.ticketsCollection);

    if (role == UserRole.employee && userId != null) {
      query = query.where('createdBy', isEqualTo: userId);
    } else if (role == UserRole.agent && userId != null) {
      query = query.where('assignedTo', isEqualTo: userId);
    }

    if (status != null) query = query.where('status', isEqualTo: status.name);
    if (category != null) query = query.where('category', isEqualTo: category.name);
    if (priority != null) query = query.where('priority', isEqualTo: priority.name);

    final snapshot = await query.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => TicketModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  @override
  Stream<List<TicketEntity>> watchTickets({
    UserRole? role,
    String? userId,
    String? category,
  }) {
    Query query = _firestore.collection(AppConstants.ticketsCollection);

    if (role == UserRole.employee && userId != null) {
      query = query.where('createdBy', isEqualTo: userId);
    } else if (role == UserRole.agent) {
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      } else if (userId != null) {
        query = query.where('assignedTo', isEqualTo: userId);
      }
    }

    return query.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TicketModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  @override
  Future<void> updateTicketStatus(String ticketId, TicketStatus status) async {
    await _firestore.collection(AppConstants.ticketsCollection).doc(ticketId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> assignTicket(String ticketId, String agentId) async {
    await _firestore.collection(AppConstants.ticketsCollection).doc(ticketId).update({
      'assignedTo': agentId,
      'status': TicketStatus.assigned.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteTicket(String ticketId) async {
    await _firestore.collection(AppConstants.ticketsCollection).doc(ticketId).delete();
  }
}
