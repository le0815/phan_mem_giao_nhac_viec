class ModelUser {
  final String email;
  final String userName;
  ModelUser({
    required this.email,
    required this.userName,
  });

  Map<String, dynamic> ToMap() {
    return {
      "email": email,
      "userName": userName,
    };
  }
}
