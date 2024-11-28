import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final _collectioName = "Chat";

  static Stream<QuerySnapshot> groupChatStream() {
    return _firebaseFirestore
        .collection(_collectioName)
        .orderBy('timeUpdate', descending: true)
        .snapshots();
  }

  Future<void> createNewChat() async {
    
  }
}
