import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('user apparently created ${userCredential.user!.email}');
      return userCredential.user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('user ${userCredential.user!.email} logged in');
      
      return userCredential.user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
