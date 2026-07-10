import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_message_handler.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repository.dart';

part 'ticket_details_state.dart';

@injectable
class TicketDetailsCubit extends Cubit<TicketDetailsState> {
  final TicketRepository _ticketRepository;

  TicketDetailsCubit(this._ticketRepository) : super(TicketDetailsInitial());

  Future<void> loadTicket(String ticketId) async {
    emit(TicketDetailsLoading());
    try {
      final ticket = await _ticketRepository.getTicketById(ticketId);
      emit(TicketDetailsLoaded(ticket));
    } catch (e) {
      emit(TicketError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> createTicket(TicketEntity ticket) async {
    emit(TicketDetailsLoading());
    try {
      await _ticketRepository.createTicket(ticket);
      emit(TicketActionSuccess());
    } catch (e) {
      emit(TicketError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> updateStatus(String ticketId, TicketStatus status) async {
    try {
      await _ticketRepository.updateTicketStatus(ticketId, status);
      loadTicket(ticketId);
    } catch (e) {
      emit(TicketError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> assign(String ticketId, String agentId) async {
    try {
      await _ticketRepository.assignTicket(ticketId, agentId);
      loadTicket(ticketId);
    } catch (e) {
      emit(TicketError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    emit(TicketDetailsLoading());
    try {
      await _ticketRepository.deleteTicket(ticketId);
      emit(TicketActionSuccess());
    } catch (e) {
      emit(TicketError(ErrorMessageHandler.map(e)));
    }
  }
}
