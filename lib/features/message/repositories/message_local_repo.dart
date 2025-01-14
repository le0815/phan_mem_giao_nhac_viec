import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/repositories/message_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';

class MessageLocalRepo {
  static final MessageLocalRepo instance = MessageLocalRepo._();
  MessageLocalRepo._();
  final Box messageHiveBox = LocalRepo.instance.chatHiveBox;
  syncData() async {
    log("start sync message data");
    // get data from database
    var data = await MessageRemoteRepo.instance
        .syncChatData(currentUID: FirebaseAuth.instance.currentUser!.uid);
    // clear the previous data
    await messageHiveBox.clear();
    // sync data
    await messageHiveBox.putAll(data);

    // sync user info of chat box
    // loop for each member uid of the chat
    log("start sync user data while syncing message data");
    (data as Map).forEach(
      (key, value) {
        ModelChat modelChat = ModelChat.fromMap((value as Map)["modelChat"]);
        modelChat.members.forEach(
          (element) async {
            await UserLocalRepo.instance.syncData(uid: element);
          },
        );
      },
    );
  }
}
