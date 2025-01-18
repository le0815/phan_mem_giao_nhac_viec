class ModelWorkspace {
  final String workspaceName;
  final int createAt;
  final List members;

  ModelWorkspace({
    required this.createAt,
    required this.workspaceName,
    required this.members,
  });

  factory ModelWorkspace.fromMap(Map<dynamic, dynamic> object) {
    return ModelWorkspace(
      createAt: object["createAt"],
      workspaceName: object["workspaceName"],
      members: object["members"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "workspaceName": workspaceName,
      "createAt": createAt,
      "members": members
    };
  }
}
