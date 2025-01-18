class UserModel {
  final String email;
  final String userName;
  final String uid;
  final List<dynamic> fcm;

  UserModel({
    required this.email,
    required this.userName,
    required this.uid,
    required this.fcm,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> object) {
    return UserModel(
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
