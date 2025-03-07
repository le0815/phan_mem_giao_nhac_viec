import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';

class WorkspaceRemoteRepo {
  static final WorkspaceRemoteRepo instance = WorkspaceRemoteRepo._();
  WorkspaceRemoteRepo._();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String _collectionName = "Workspace";

  Future createWorkspace({
    required String currentUID,
    required ModelWorkspace modelWorkspace,
  }) async {
    var mainCollection = await _firebaseFirestore
        .collection(_collectionName)
        .add(modelWorkspace.toMap());
    // add 'MembersDetail' subcollection after create main docs
    await mainCollection.collection("MembersDetail").doc(currentUID).set({
      "role": MyWorkspaceRole.owner.name,
    });
  }

  Future getWorkspaceData({required String workspaceDocID}) async {
    var mainCollection = await _firebaseFirestore
        .collection(_collectionName)
        .doc(workspaceDocID);
    var result = await mainCollection.get();
    var modelWorkspace = ModelWorkspace.fromMap(result.data()!);

    /// get MembersDetail collection inside the main collection
    var subCollection = await mainCollection.collection("MembersDetail").get();
    var membersDetail = {};
    for (var element in subCollection.docs) {
      membersDetail.addAll({
        element.id: element.data(),
      });
    }

    /// the transformed data
    // {
    //   'modelWorkspace': instance of modelWorkspace,
    //   'membersDetail': {
    //       UID_1 : {
    //               role : role name 1,
    //       },
    //       UID_2 : {
    //               role : role name 2,
    //       },
    //   }
    // }
    return {'modelWorkspace': modelWorkspace, 'membersDetail': membersDetail};
  }

  addUser(
      {required String docID,
      required String uid,
      required List newMemberList}) async {
    // first get doc ref
    var mainCollection =
        _firebaseFirestore.collection(_collectionName).doc(docID);

    // update member
    await mainCollection.update({
      "members": newMemberList,
    });

    // add 'MembersDetail' sub collection after create main docs
    await mainCollection.collection("MembersDetail").doc(uid).set({
      "role": MyWorkspaceRole.member.name,
    });
  }

  Future<void> deleteWorkspace(String workspaceID) async {
    log("removing workspace from firebase");
    // get workspace doc
    var workspaceDoc =
        _firebaseFirestore.collection("Workspace").doc(workspaceID);
    var subCollection = await workspaceDoc.collection("MembersDetail").get();

    // delete sub collection first
    for (var element in subCollection.docs) {
      await workspaceDoc.collection("MembersDetail").doc(element.id).delete();
    }
    // delete workspace
    await workspaceDoc.delete();

    // delete tasks of workspace
    // get all taskID of workspace task
    var tasksID = await _firebaseFirestore
        .collection("Task")
        .where("workspaceID", isEqualTo: workspaceID)
        .get();

    // delete task
    for (var element in tasksID.docs) {
      await _firebaseFirestore.collection("Task").doc(element.id).delete();
    }
  }

  Future<void> leaveWorkspace({
    required String workspaceID,
    required String uid,
    required ModelWorkspace modelWorkspace,
    required Map membersDetail,
  }) async {
    log("leaving workspace from firebase");
    // remove uid from database
    modelWorkspace.members.removeWhere((element) => element == uid);
    membersDetail.remove(uid);

    // update to database
    var mainCollection =
        _firebaseFirestore.collection(_collectionName).doc(workspaceID);

    // update main collection
    await mainCollection.set(modelWorkspace.toMap());
    // update memberDetail sub collection
    var subCollection = await mainCollection.collection("MembersDetail").get();
    for (var element in subCollection.docs) {
      if (!membersDetail.containsKey(element.id)) {
        await mainCollection
            .collection("MembersDetail")
            .doc(element.id)
            .delete();
      }
    }
    // move all related task
    var tasks = await _firebaseFirestore
        .collection("Task")
        .where("workspaceID", isEqualTo: workspaceID)
        .where("uid", isEqualTo: uid)
        .get();

    for (var element in tasks.docs) {
      await _firebaseFirestore.collection("Task").doc(element.id).delete();
    }
  }

  Future syncData({required String currentUID}) async {
    log("fetching data from firebase");

    var mainCollection = _firebaseFirestore
        .collection(_collectionName)
        .where("members", arrayContains: currentUID);
    var result = await mainCollection.get();
    var totalResult = {};
    // get the main collection
    for (var element in result.docs) {
      var modelWorkspace = element.data();

      /// get MembersDetail collection inside the main collection
      var subCollection =
          await element.reference.collection("MembersDetail").get();
      var membersDetail = {};
      for (var subElement in subCollection.docs) {
        membersDetail.addAll(
          {
            subElement.id: subElement.data(),
          },
        );
      }

      totalResult.addAll(
        {
          element.id: {
            "modelWorkspace": modelWorkspace,
            "membersDetail": membersDetail
          }
        },
      );
    }

    /// the transformed data
    // { doc id of workspace:
    //     {
    //     'modelWorkspace': instance of modelWorkspace,
    //     'membersDetail': {
    //         UID_1 : {
    //                 role : role name 1,
    //         },
    //         UID_2 : {
    //                 role : role name 2,
    //         },
    //     }
    //   }
    // }
    return totalResult;
  }
}
