import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';

class AuthViewModel extends ChangeNotifier {
  static final AuthViewModel instance = AuthViewModel._();
  AuthViewModel._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLogin = false;
  String? password;

  bool isLoading = false;

  User? _user;
  User? get user => _user;

  checkLoginState() {
    isLogin = FirebaseAuth.instance.currentUser == null ? false : true;
    notifyListeners();
  }

  // sign in
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      log("signing");
      isLogin = true;
      isLoading = true;
      notifyListeners();
      _user = userCredential.user;
      if (_user?.uid != null) {
        // add new fcm token to database
        var queryData =
            await UserRemoteRepo.instance.getUserByUID(uid: _user!.uid);
        UserModel modelUser = UserModel.fromMap(queryData.data());

        var newFcmToken = await FirebaseMessaging.instance.getToken();
        // if the fcm token already exist in the database -> return
        if (!modelUser.fcm.contains(newFcmToken)) {
          modelUser.fcm.add(newFcmToken!);
          UserRemoteRepo.instance
              .updateUserInfoToDatabase(modelUser: modelUser);
        }

        // clear old data
        await LocalRepo.instance.clearAllData();
        // sync new data from firebase
        await LocalRepo.instance.syncAllData();

        isLoading = false;
        notifyListeners();
      }

      return userCredential;
    } catch (e) {
      isLoading = false;
      isLogin = false;
      notifyListeners();
      log('error while signin: ${e.toString()}.');
      throw Exception(e.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      log("signing out");
      // remove fcmToken
      await UserRemoteRepo.instance
          .removeUserFcmToken(uid: FirebaseAuth.instance.currentUser!.uid);
      // clear hive box data
      await LocalRepo.instance.clearAllData();
      await _firebaseAuth.signOut();
      isLogin = false;
      notifyListeners();
    } catch (e) {
      log("error while signing out");
      throw Exception(e);
    }
  }

  // register
  registerWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String userName,
  }) async {
    if (password != confirmPassword) {
      throw "Password must match!";
    }
    try {
      // register user
      isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // get fcm token
        List fcm = [await FirebaseMessaging.instance.getToken()];
        var uid = userCredential.user!.uid;
        UserModel userModel =
            UserModel(email: email, userName: userName, uid: uid, fcm: fcm);
        // save user data to db
        await UserRemoteRepo.instance.createUser(userModel: userModel);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log('error while register: ${e.toString()}.');
      throw Exception(e.toString());
    }
  }
}
