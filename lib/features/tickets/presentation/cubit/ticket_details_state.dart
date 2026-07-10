part of 'ticket_details_cubit.dart';

abstract class TicketDetailsState extends Equatable {
  const TicketDetailsState();

  @override
  List<Object?> get props => [];
}

class TicketDetailsInitial extends TicketDetailsState {}

class TicketDetailsLoading extends TicketDetailsState {}

class TicketDetailsLoaded extends TicketDetailsState {
  final TicketEntity ticket;
  const TicketDetailsLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketActionSuccess extends TicketDetailsState {}

class TicketError extends TicketDetailsState {
  final String message;
  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
