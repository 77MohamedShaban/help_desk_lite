import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_message_handler.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';

part 'ticket_list_state.dart';

@injectable
class TicketListCubit extends Cubit<TicketListState> {
  final TicketRepository _ticketRepository;
  StreamSubscription? _ticketSubscription;

  TicketListCubit(this._ticketRepository) : super(TicketListInitial());

  void watchUserTickets(String userId) {
    emit(TicketListLoading());
    _ticketSubscription?.cancel();
    _ticketSubscription = _ticketRepository
        .watchTickets(role: UserRole.employee, userId: userId)
        .listen(
      (tickets) {
        emit(TicketListLoaded(tickets));
      },
      onError: (e) {
        emit(TicketListError(ErrorMessageHandler.map(e)));
      },
    );
  }

  void watchAgentTickets(String agentId) {
    emit(TicketListLoading());
    _ticketSubscription?.cancel();
    _ticketSubscription = _ticketRepository
        .watchTickets(role: UserRole.agent, userId: agentId)
        .listen(
      (tickets) {
        emit(TicketListLoaded(tickets));
      },
      onError: (e) {
        emit(TicketListError(ErrorMessageHandler.map(e)));
      },
    );
  }

  void watchDepartmentTickets(String category) {
    emit(TicketListLoading());
    _ticketSubscription?.cancel();
    _ticketSubscription = _ticketRepository
        .watchTickets(role: UserRole.agent, category: category)
        .listen(
      (tickets) {
        emit(TicketListLoaded(tickets));
      },
      onError: (e) {
        emit(TicketListError(ErrorMessageHandler.map(e)));
      },
    );
  }

  void watchAllTickets() {
    emit(TicketListLoading());
    _ticketSubscription?.cancel();
    _ticketSubscription = _ticketRepository.watchTickets().listen(
      (tickets) {
        emit(TicketListLoaded(tickets));
      },
      onError: (e) {
        emit(TicketListError(ErrorMessageHandler.map(e)));
      },
    );
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      await _ticketRepository.deleteTicket(ticketId);
    } catch (e) {
      emit(TicketListError(ErrorMessageHandler.map(e)));
    }
  }

  @override
  Future<void> close() {
    _ticketSubscription?.cancel();
    return super.close();
  }
}
