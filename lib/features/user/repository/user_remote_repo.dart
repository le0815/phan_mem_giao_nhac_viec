import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';

class UserRemoteRepo {
  static final UserRemoteRepo instance = UserRemoteRepo._();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserRemoteRepo._();

  Future getUserByUID({required uid}) async {
    log("fetching user data from firebase");
    var result = await _firebaseFirestore.collection("User").doc(uid).get();
    return result;
  }

  Future<Map> searchUserByPhrase({required String searchPhrase}) async {
    log("searching user by phrase: $searchPhrase");
    Map result = {};
    var data = await _firebaseFirestore
        .collection("User")
        .where("userName", isEqualTo: searchPhrase)
        .get();
    for (var element in data.docs) {
      result.addAll({element.id: element.data()});
    }
    return result;
  }

  // save usr info to database with id of the doc is uid
  Future<void> updateUserInfoToDatabase({required UserModel modelUser}) async {
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
  Future<void> createUser({required UserModel userModel}) async {
    try {
      log("start creating user in firebase");

      await _firebaseFirestore
          .collection("User")
          .doc(userModel.uid)
          .set(userModel.ToMap());
    } catch (e) {
      log("err while uploading user info to database: $e");
      throw Exception(e);
    }
  }

  Future removeUserFcmToken({required String uid}) async {
    log("removing fcm token");
    // get current user info
    UserModel modelUser =
        UserModel.fromMap(UserLocalRepo.instance.getModelUser(uid: uid));

    // current fcm token
    var fcmToken = await FirebaseMessaging.instance.getToken();
    // remove fcm token of device
    modelUser.fcm.removeWhere((element) => element == fcmToken);

    updateUserInfoToDatabase(modelUser: modelUser);
  }
}
