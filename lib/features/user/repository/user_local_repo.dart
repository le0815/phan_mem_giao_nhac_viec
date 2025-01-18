import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';

class UserLocalRepo {
  static final UserLocalRepo instance = UserLocalRepo._();
  UserLocalRepo._();
  final Box userHiveBox = LocalRepo.instance.userHiveBox;

  syncData({required String uid}) async {
    log("start sync user data");
    if (!userHiveBox.containsKey(uid)) {
      var result = await UserRemoteRepo.instance.getUserByUID(uid: uid);
      // data was stored in hive followed by form
      // {
      //   uid : modelUser
      // }
      await userHiveBox.putAll({result.id: result.data()});
    }
  }

  getModelUser({required String uid}) {
    log("getting model user");
    var result = userHiveBox.toMap()[uid];
    return result;
  }
}
