import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';

class ChatService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static const _collectionName = "Chat";

  static Stream<QuerySnapshot> groupChatStream() {
    return _firebaseFirestore
        .collection(_collectionName)
        .orderBy('timeUpdate', descending: true)
        .snapshots();
  }

  Future<void> createNewChat({
    required String chatName,
    required List members,
    required Timestamp timeUpdate,
  }) async {
    _firebaseFirestore.collection(_collectionName).add(ModelChat(
          chatName: chatName,
          members: members,
          timeUpdate: timeUpdate,
        ).toMap());
  }
}
