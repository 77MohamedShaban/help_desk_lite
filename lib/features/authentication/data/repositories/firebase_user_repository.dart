import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserRepository)
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository(this._firestore);

  @override
  Future<UserEntity?> getUserById(String uid) async {
    final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc.data()!);
  }

  @override
  Future<List<UserEntity>> getUsersByRole(UserRole role) async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: role.name)
        .get();
    
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc.data())).toList();
  }
}
