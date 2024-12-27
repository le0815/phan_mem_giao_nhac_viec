import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';

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

      if (_user?.uid != null) {
        // add new fcm token to database
        ModelUser modelUser =
            await DatabaseService.instance.getUserByUID(_user!.uid);
        var newFcmToken = await FirebaseMessaging.instance.getToken();
        // if the fcm token already exist in the database -> return
        if (!modelUser.fcm.contains(newFcmToken)) {
          modelUser.fcm.add(newFcmToken!);
          updateUserInfoToDatabase(modelUser);
        }

        // clear old data
        await HiveBoxes.instance.clearAllData();
        // sync new data from firebase
        HiveBoxes.instance.syncAllData();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('error while signin: ${e.code}.');
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> SignOut() async {
    try {
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
  Future<void> updateUserInfoToDatabase(ModelUser modelUser) async {
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
      await _firebaseFirestore.collection("User").doc(uid).set(ModelUser(
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
