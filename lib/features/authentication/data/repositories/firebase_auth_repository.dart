import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    final doc = await _firestore.collection(AppConstants.usersCollection).doc(user.uid).get();
    if (!doc.exists) return null;
    
    return UserModel.fromFirestore(doc.data()!);
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    final credentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(credentials.user!.uid)
        .get();
    
    if (!doc.exists) {
      throw Exception("User profile not found in Firestore");
    }
    
    return UserModel.fromFirestore(doc.data()!);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String department,
  }) async {
    final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      uid: credentials.user!.uid,
      name: name,
      email: email,
      role: role,
      department: department,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userModel.uid)
        .set(userModel.toFirestore());

    return userModel;
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();

  @override
  Future<void> resetPassword(String email) => _firebaseAuth.sendPasswordResetEmail(email: email);

  @override
  Stream<UserEntity?> get onAuthStateChanged => _firebaseAuth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;
    try {
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc.data()!);
    } catch (_) {
      return null;
    }
  });
}
