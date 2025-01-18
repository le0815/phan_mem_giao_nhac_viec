import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/repositories/workspace_remote_repo.dart';

class WorkspaceLocalRepo {
  static final WorkspaceLocalRepo instance = WorkspaceLocalRepo._();
  WorkspaceLocalRepo._();
  final Box workspaceHiveBox = LocalRepo.instance.workspaceHiveBox;

  syncData() async {
    log("start sync workspace data");
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    var result =
        await WorkspaceRemoteRepo.instance.syncData(currentUID: currentUID);

    // clear the previous data
    await workspaceHiveBox.clear();
    // sync data
    await workspaceHiveBox.putAll(result);

    // sync user info of workspace
    // loop for each member uid of the workspace
    log("start sync user data while syncing message data");
    (result as Map).forEach(
      (key, value) {
        ModelWorkspace modelWorkspace =
            ModelWorkspace.fromMap((value as Map)["modelWorkspace"]);
        modelWorkspace.members.forEach(
          (element) async {
            await UserLocalRepo.instance.syncData(uid: element);
          },
        );
      },
    );
  }
}
