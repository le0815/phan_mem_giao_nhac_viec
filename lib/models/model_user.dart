class ModelUser {
  final String email;
  ModelUser({
    required this.email,
  });

  Map<String, dynamic> ToMap()
  {
    return {
      "email": email,
    };
  }
}
