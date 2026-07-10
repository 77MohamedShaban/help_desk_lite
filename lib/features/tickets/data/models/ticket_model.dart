import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ticket_entity.dart';

class TicketModel extends TicketEntity {
  const TicketModel({
    required super.ticketId,
    required super.title,
    required super.description,
    required super.category,
    required super.priority,
    required super.status,
    required super.createdBy,
    super.assignedTo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TicketModel.fromFirestore(Map<String, dynamic> json, String id) {
    return TicketModel(
      ticketId: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: TicketCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TicketCategory.general,
      ),
      priority: TicketPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TicketPriority.low,
      ),
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.newTicket,
      ),
      createdBy: json['createdBy'] ?? '',
      assignedTo: json['assignedTo'],
      // معالجة حالة التوقيت عندما يكون null في التحديثات المحلية قبل وصوله للسيرفر
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.now(), 
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.name,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      // نستخدم serverTimestamp لضمان دقة الوقت في السيرفر وترتيب القائمة بشكل صحيح
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
