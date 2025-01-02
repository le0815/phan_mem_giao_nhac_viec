import 'package:hive/hive.dart';

part "model_user.g.dart";

@HiveType(typeId: 4)
class ModelUser {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String uid;
  @HiveField(3)
  final List<dynamic> fcm;

  ModelUser({
    required this.email,
    required this.userName,
    required this.uid,
    required this.fcm,
  });

  factory ModelUser.fromMap(Map<String, dynamic> object) {
    return ModelUser(
      email: object["email"],
      userName: object["userName"],
      uid: object["uid"],
      fcm: object["fcm"],
    );
  }

  Map<String, dynamic> ToMap() {
    return {
      "email": email,
      "userName": userName,
      "uid": uid,
      "fcm": fcm,
    };
  }
}
