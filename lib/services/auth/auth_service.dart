import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String? password;

  User? _user;

  User? get user => _user;

  // sign in
  Future<UserCredential> SignInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      log("signing");
      _user = userCredential.user;

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
      // register user
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.credential != null) {
        _firebaseAuth.signInWithCredential(userCredential.credential!);
      }

      // save user data to db
      await SaveInfoToDatabase(
        userCredential,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('error while register: ${e.code}.');
      throw Exception(e.code);
    }
  }

  // save usr info to database with id of the doc is uid
  Future<void> SaveInfoToDatabase(UserCredential userCredential) async {
    try {
      log("start uploading user info to database");
      await _firebaseFirestore
          .collection("User")
          .doc(userCredential.user!.uid)
          .set(ModelUser(email: userCredential.user!.email.toString()).ToMap());
    } catch (e) {
      log("err while uploading user info to database: $e");
      throw Exception(e);
    }
  }
}
