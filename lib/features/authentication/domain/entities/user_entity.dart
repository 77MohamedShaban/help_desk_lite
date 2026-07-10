import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, name, email, role, department, createdAt];
}
