import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';

class WorkspaceService {
  static final WorkspaceService instance = WorkspaceService._();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final String _collectionName = "Workspace";

  WorkspaceService._();

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
        await _firebaseFirestore.collection(_collectionName).doc(docID);

    // update member
    await mainCollection.update({
      "members": newMemberList,
    });

    // add 'MembersDetail' subcollection after create main docs
    await mainCollection.collection("MembersDetail").doc(uid).set({
      "role": MyWorkspaceRole.member.name,
    });
  }

  Stream<QuerySnapshot> workspaceStream(String currentUID) {
    return _firebaseFirestore
        .collection(_collectionName)
        .where("members", arrayContains: currentUID)
        .snapshots();
  }

  Future workspaceFuture({required String currentUID}) async {
    var mainCollection = await _firebaseFirestore
        .collection(_collectionName)
        .where("members", arrayContains: currentUID);
    var result = await mainCollection.get();
    var totalResult = {};
    for (var element in result.docs) {
      var modelWorkspace = ModelWorkspace.fromMap(element.data());

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
