import 'dart:convert';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/services.dart';

Future readJsonFile(String filePath) async {
  var input = await rootBundle.loadString(filePath);
  // var json = jsonDecode(input);
  var temp = jsonDecode(input);
  return temp;
}

String myLoremIpsum() {
  return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
}

Future checkConnectionState() async {
  final result = await Ping('google.com', count: 1).stream.first;
  return result.error;
}
