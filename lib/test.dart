import 'dart:convert';
import 'dart:io';

// Future<List<Map>> readJsonFile(String filePath) async {
//   var input = await File(filePath).readAsString();
//   var map = jsonDecode(input);
//   return map['users'];
// }
Future readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  // var json = jsonDecode(input);
  var temp = jsonEncode(input);
  return temp;
}

void main() async {
  var authorization = await readJsonFile(
      "/home/ha/Desktop/Flutter/phan_mem_giao_nhac_viec/API_KEY/nckhflutter_bac6d88f6505.json");
  print(authorization);
}
