import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/translate/v3.dart';
import 'package:hive/hive.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_message.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/repositories/message_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/repositories/message_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';

class MessageViewModel extends ChangeNotifier {
  static final MessageViewModel instance = MessageViewModel._();
  MessageViewModel._();

  final Box chatHiveBox = LocalRepo.instance.chatHiveBox;

  Map _searchResult = {};
  Map get searchResult => _searchResult;

  searchUserByPhrase({required String searchPhrase}) async {
    _searchResult = await UserRemoteRepo.instance
        .searchUserByPhrase(searchPhrase: searchPhrase);
    log("search result: $_searchResult");
    notifyListeners();
  }

  createNewChat({required UserModel modelUser}) async {
    // check if chat was existed
    if (checkChatExist(memberUID: modelUser.uid)) {
      throw "Chat was already existed";
    }

    List chatMembers = [modelUser.uid, FirebaseAuth.instance.currentUser!.uid];
    int timeUpdate = DateTime.now().millisecondsSinceEpoch;
    await MessageRemoteRepo.instance.createNewChat(
      chatName: modelUser.userName,
      members: chatMembers,
      timeUpdate: timeUpdate,
    );

    // sync message data
    MessageLocalRepo.instance.syncData();

    // send notification
    // LocalRepo.instance.syncData(syncType: SyncTypes.syncMessage);
    NotificationService.instance.sendNotification(
        receiverToken: modelUser.fcm,
        title: "You have a new conversation with ${modelUser.userName}",
        payload: {
          "notificationType": "remote",
          "0": SyncTypes.syncMessage,
        });
  }

  bool checkChatExist({required String memberUID}) {
    bool isExisted = false;
    chatHiveBox.toMap().forEach(
      (key, value) {
        ModelChat modelChat = ModelChat.fromMap((value as Map)["modelChat"]);
        if (modelChat.members.contains(memberUID)) {
          isExisted = true;
          return;
        }
      },
    );
    return isExisted;
  }

  getLatestMessageOfChat({required Map chatData}) {
    // find the latest message, other wise return null
    Map totalMessages = chatData["modelMessages"];
    var lastMessage = totalMessages.values.lastOrNull;
    if (lastMessage != null) {
      ModelMessage modelMessage =
          ModelMessage.fromMap(totalMessages.values.lastOrNull);
      return modelMessage;
    }
    return null;
  }

  UserModel getMemberModelUser({required ModelChat modelChat}) {
    var memberUID = modelChat.members.first;
    UserModel userModel = UserModel.fromMap(
      UserLocalRepo.instance.getModelUser(uid: memberUID),
    );
    return userModel;
  }

  sendMessage({
    required String message,
    required UserModel memberUserModel,
    required String chatDocID,
  }) async {
    if (message.isEmpty) {
      log("empty message -> return");
      return;
    }
    try {
      int timeSend = DateTime.now().millisecondsSinceEpoch;
      String senderUID = FirebaseAuth.instance.currentUser!.uid;
      ModelMessage modelMessage = ModelMessage(
          message: message, timeSend: timeSend, senderUID: senderUID);

      // store message to firebase
      await MessageRemoteRepo.instance.sendMessage(
        chatDocID: chatDocID,
        modelMessage: modelMessage,
      );

      // notify to user in chat box
      NotificationService.instance.sendNotification(
          receiverToken: memberUserModel.fcm,
          title: "You have new message from ${memberUserModel.userName}",
          body: message,
          payload: {
            "notificationType": "remote",
            '0': SyncTypes.syncMessage,
          });

      // sync messageData
      MessageLocalRepo.instance.syncData();
    } catch (e) {
      throw "err while sending message: ${e.toString()}";
    }
  }
}
