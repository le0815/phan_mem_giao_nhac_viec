import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';

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
}
