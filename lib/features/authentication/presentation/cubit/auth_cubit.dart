import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_message_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _authRepository.onAuthStateChanged.listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String department,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        role: role,
        department: department,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      emit(AuthError(ErrorMessageHandler.map(e)));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
