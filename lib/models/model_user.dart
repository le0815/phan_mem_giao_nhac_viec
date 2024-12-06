class ModelUser {
  final String email;
  final String userName;
  final String uid;
  ModelUser({
    required this.email,
    required this.userName,
    required this.uid,
  });

  Map<String, dynamic> ToMap() {
    return {
      "email": email,
      "userName": userName,
      "uid": uid,
    };
  }
}
