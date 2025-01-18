class ModelMemberDetail {
  final String role;

  ModelMemberDetail({required this.role});
  factory ModelMemberDetail.fromMap(Map object) {
    return ModelMemberDetail(
      role: object["role"],
    );
  }

  toMap() {
    return {"role": role};
  }
}
