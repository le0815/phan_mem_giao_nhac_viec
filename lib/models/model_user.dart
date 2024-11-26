class ModelUser {
  final String uid;
  final String email;
  ModelUser({
    required this.uid,
    required this.email,
  });

  Map<String, dynamic> ToMap()
  {
    return {
      "uid": uid,
      "email": email,
    };
  }
}
