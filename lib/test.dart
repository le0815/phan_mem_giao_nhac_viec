import 'dart:convert';

import 'package:dart_ping/dart_ping.dart';

import 'constraint/constraint.dart';

void main() async {
  // final Map<String, dynamic> message = {
  //   "message": {
  //     "token": "token",
  //     "notification": {
  //       "title": "title",
  //       "body": "body",
  //     },
  //     // "data": {
  //     //   0: SyncTypes.syncMessage,
  //     // },
  //   },
  // };
  Map message = {"asdsa": "sfdsd"};
  print(jsonEncode(message));
}
