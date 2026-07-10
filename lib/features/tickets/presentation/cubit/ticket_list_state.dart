part of 'ticket_list_cubit.dart';

abstract class TicketListState extends Equatable {
  const TicketListState();

  @override
  List<Object?> get props => [];
}

class TicketListInitial extends TicketListState {}

class TicketListLoading extends TicketListState {}

class TicketListLoaded extends TicketListState {
  final List<TicketEntity> tickets;
  const TicketListLoaded(this.tickets);

  @override
  List<Object?> get props => [tickets];
}

class TicketListError extends TicketListState {
  final String message;
  const TicketListError(this.message);

  @override
  List<Object?> get props => [message];
}
