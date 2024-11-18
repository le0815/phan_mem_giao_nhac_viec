import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign in
  Future<UserCredential> SignInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('error while signin: ${e.code}.');
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> SignOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log("error while signing out");
      throw Exception(e);
    }
  }

  // register
  Future<UserCredential> RegisterWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('error while register: ${e.code}.');
      throw Exception(e.code);
    }
  }
}
