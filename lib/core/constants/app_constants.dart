class AppConstants {
  static const String appName = 'HelpDesk Lite';
  
  // Firestore Collection Names
  static const String usersCollection = 'users';
  static const String ticketsCollection = 'tickets';
  static const String commentsCollection = 'comments';
}

enum UserRole { employee, agent, manager }

enum TicketStatus { newTicket, assigned, inProgress, resolved, closed }

enum TicketPriority { low, medium, high, urgent }

enum TicketCategory { it, hr, finance, facilities, general }
