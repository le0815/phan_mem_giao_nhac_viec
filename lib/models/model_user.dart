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

  Map<String, dynamic> ToMap() {
    return {
      "email": email,
      "userName": userName,
      "uid": uid,
      "fcm": fcm,
    };
  }
}
