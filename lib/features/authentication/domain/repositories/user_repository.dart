import '../entities/user_entity.dart';
import '../../../../core/constants/app_constants.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsersByRole(UserRole role);
  Future<UserEntity?> getUserById(String uid);
}
