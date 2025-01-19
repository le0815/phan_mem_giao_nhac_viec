import 'package:firebase_auth/firebase_auth.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';

class UserViewModel {
  static final UserViewModel instance = UserViewModel._();
  UserViewModel._();

  String getIconText({required String userName}) {
    return userName.substring(0, 1).toUpperCase();
  }

  getCurrentUser() async {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    Map? result = UserLocalRepo.instance.getModelUser(uid: currentUID);
    // if current user is not loaded yet
    if (result == null) {
      var remoteData =
          await UserRemoteRepo.instance.getUserByUID(uid: currentUID);
      result = remoteData.data();
    }

    return result;
  }
}
