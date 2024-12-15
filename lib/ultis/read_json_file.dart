import 'dart:convert';
import 'dart:io';

Future readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  // var json = jsonDecode(input);
  var temp = jsonEncode(input);
  return temp;
}
