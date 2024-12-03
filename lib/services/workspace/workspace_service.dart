import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';

class WorkspaceService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final String _collectionName = "Workspace";

  static Future createWorkspace({
    required String currentUID,
    required ModelWorkspace modelWorkspace,
  }) async {
    var mainCollection = await _firebaseFirestore
        .collection(_collectionName)
        .add(modelWorkspace.toMap());
    // add 'member' subcollection after create main docs
    await mainCollection.collection("Members").doc(currentUID).set({
      "role": 0,
    });
  }

  static Stream<QuerySnapshot> workspaceStream(String currentUID) {
    return _firebaseFirestore
        .collection(_collectionName)
        .where("workspaceMembers", arrayContains: currentUID)
        .snapshots();
  }
}
