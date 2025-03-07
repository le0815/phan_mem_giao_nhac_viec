import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';

class UserViewModel extends ChangeNotifier {
  static final UserViewModel instance = UserViewModel._();
  UserViewModel._();

  bool isLoading = false;

  String getIconText({required String userName}) {
    return userName.substring(0, 1).toUpperCase();
  }

  loadingOn() {
    isLoading = true;
    notifyListeners();
  }

  loadingOff() {
    isLoading = false;
    notifyListeners();
  }

  Future<UserModel> getUserModel() async {
    loadingOn();
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    var result = await UserRemoteRepo.instance.getUserByUID(uid: currentUID);
    UserModel userModel = UserModel.fromMap(result.data());
    loadingOff();
    return userModel;
  }

  Future validPwd(
      {required String newPwd,
      required String confirmPwd,
      required String currentPwd}) async {
    // remove blank space at both ends of string
    newPwd = newPwd.trim();
    confirmPwd = confirmPwd.trim();
    if (newPwd != confirmPwd) {
      throw "Password must match!";
    }
    if (newPwd.isEmpty || confirmPwd.isEmpty) {
      throw "All the fields must be filled!";
    }

    loadingOn();

    // validate current pwd
    try {
      await UserRemoteRepo.instance.validatePwd(currentPwd: currentPwd);
    } catch (e) {
      loadingOff();
      throw "Invalid current password!";
    }

    // update pwd
    try {
      await UserRemoteRepo.instance.updatePwd(newPwd: newPwd);
    } catch (e) {
      loadingOff();
      throw e.toString();
    }

    loadingOff();
  }
}
