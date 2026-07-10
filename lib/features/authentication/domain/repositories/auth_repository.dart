import '../entities/user_entity.dart';
import '../../../../core/constants/app_constants.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String department,
  });
  Future<void> logout();
  Future<void> resetPassword(String email);
  Stream<UserEntity?> get onAuthStateChanged;
}
