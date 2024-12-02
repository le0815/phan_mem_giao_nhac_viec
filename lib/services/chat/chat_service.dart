import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_message.dart';

class ChatService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static const _collectionName = "Chat";
  static const _messageCollection = "Message";

  static Stream<QuerySnapshot> groupChatStream() {
    return _firebaseFirestore
        .collection(_collectionName)
        .orderBy('timeUpdate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> messageStream(String chatCollection) {
    return _firebaseFirestore
        .collection(_collectionName)
        .doc(chatCollection)
        .collection(_messageCollection)
        .orderBy('timeSend', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({required ModelMessage modelMessage}) async {
    await _firebaseFirestore
        .collection(_collectionName)
        .doc(modelMessage.chatCollection)
        .collection(modelMessage.messageCollection)
        .add(modelMessage.toMap());
  }

  static Future<void> createNewChat({
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
