import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static const _collectionName = "Chat";

  static Stream<QuerySnapshot> groupChatStream() {
    return _firebaseFirestore
        .collection(_collectionName)
        .orderBy('timeUpdate', descending: true)
        .snapshots();
  }

  Future<void> createNewChat() async {
  }
}
