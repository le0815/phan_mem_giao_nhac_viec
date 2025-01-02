import 'package:hive/hive.dart';

part "model_member_detail.g.dart";

@HiveType(typeId: 5)
class ModelMemberDetail {
  @HiveField(0)
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
