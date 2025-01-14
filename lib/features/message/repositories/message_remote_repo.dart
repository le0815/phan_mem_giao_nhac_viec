import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_message.dart';

class MessageRemoteRepo {
  static final MessageRemoteRepo instance = MessageRemoteRepo._();
  MessageRemoteRepo._();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static const _collectionName = "Chat";
  static const _messageCollection = "Message";

  Stream<QuerySnapshot> groupChatStream(String currentUID) {
    return _firebaseFirestore
        .collection(_collectionName)
        .where("members", arrayContains: currentUID)
        // .orderBy('timeUpdate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> messageStream(String chatCollection) {
    return _firebaseFirestore
        .collection(_collectionName)
        .doc(chatCollection)
        .collection(_messageCollection)
        .orderBy('timeSend', descending: false)
        .snapshots();
  }

  Future syncChatData({required String currentUID}) async {
    log("syncing chat data from firebase");
    var result = {};
    var mainCollection = await _firebaseFirestore
        .collection(_collectionName)
        .where("members", arrayContains: currentUID);

    // get data of chat
    var mainCollectionDataDoc = await mainCollection.get();
    for (var mainDoc in mainCollectionDataDoc.docs) {
      var modelChat = mainDoc.data();
      var chatID = mainDoc.id;

      // message is sub collection of chat collection
      var messagesDataDoc = await mainDoc.reference
          .collection(_messageCollection)
          .orderBy("timeSend", descending: false)
          .get();
      var messagesData = {};
      for (var subDoc in messagesDataDoc.docs) {
        var messageId = subDoc.id;
        var modelMessage = subDoc.data();

        messagesData[messageId] = modelMessage;
      }
      result[chatID] = {"modelChat": modelChat, "modelMessages": messagesData};
    }
    return result;
  }

  Future<void> sendMessage(
      {required ModelMessage modelMessage, required chatDocID}) async {
    log("sending message to firebase");
    await _firebaseFirestore
        .collection(_collectionName)
        .doc(chatDocID)
        .collection(_messageCollection)
        .add(modelMessage.toMap());
  }

  Future<void> createNewChat({
    required String chatName,
    required List members,
    required int timeUpdate,
  }) async {
    log("creating chat box in firebase");
    _firebaseFirestore.collection(_collectionName).add(ModelChat(
          chatName: chatName,
          members: members,
          timeUpdate: timeUpdate,
        ).toMap());
  }
}
