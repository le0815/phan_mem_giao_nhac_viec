import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';

class AuthViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isLogin = true;
  String? password;

  User? _user;

  User? get user => _user;

  // sign in
  Future<UserCredential> SignInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      log("signing");
      _user = userCredential.user;

      if (_user?.uid != null) {
        // add new fcm token to database
        UserModel modelUser =
            await DatabaseService.instance.getUserByUID(_user!.uid);
        var newFcmToken = await FirebaseMessaging.instance.getToken();
        // if the fcm token already exist in the database -> return
        if (!modelUser.fcm.contains(newFcmToken)) {
          modelUser.fcm.add(newFcmToken!);
          updateUserInfoToDatabase(modelUser);
        }

        // clear old data
        await LocalRepo.instance.clearAllData();
        // sync new data from firebase
        LocalRepo.instance.syncAllData();
      }

      return userCredential;
    } catch (e) {
      log('error while signin: ${e.toString()}.');
      throw Exception(e.toString());
    }
  }

  // sign out
  Future<void> SignOut() async {
    try {
      log("signing out");
      // remove fcmToken
      await NotificationService.instance.removeFcmToken();
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
    String userName,
    List<String> fcm,
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
        userName,
        fcm,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('error while register: ${e.code}.');
      throw Exception(e.code);
    }
  }

  // save usr info to database with id of the doc is uid
  Future<void> updateUserInfoToDatabase(UserModel modelUser) async {
    try {
      log("start uploading user info to database");
      await _firebaseFirestore
          .collection("User")
          .doc(modelUser.uid)
          .set(modelUser.ToMap());
    } catch (e) {
      log("err while uploading user info to database: $e");
      throw Exception(e);
    }
  }

  // save usr info to database with id of the doc is uid
  Future<void> SaveInfoToDatabase(
      UserCredential userCredential, String userName, List<String> fcm) async {
    try {
      log("start uploading user info to database");
      String uid = userCredential.user!.uid;
      await _firebaseFirestore.collection("User").doc(uid).set(UserModel(
            email: userCredential.user!.email.toString(),
            userName: userName,
            uid: uid,
            fcm: fcm,
          ).ToMap());
    } catch (e) {
      log("err while uploading user info to database: $e");
      throw Exception(e);
    }
  }
}
