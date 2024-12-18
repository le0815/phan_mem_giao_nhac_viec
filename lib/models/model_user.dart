class ModelUser {
  final String email;
  final String userName;
  final String uid;
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
