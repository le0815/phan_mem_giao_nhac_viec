class TaskModel {
  String title;
  String description;
  String state;
  String? assigner;
  String? workspaceID;
  int? due;
  int? startTime;
  int createAt;
  String uid;
  int timeUpdate;
  // final String? idTask;

  TaskModel({
    required this.createAt,
    required this.title,
    required this.description,
    required this.uid,
    required this.state,
    required this.timeUpdate,
    this.due,
    this.assigner,
    this.workspaceID,
    this.startTime,
    // this.idTask,
  });

  factory TaskModel.fromMap(Map<dynamic, dynamic> object) {
    return TaskModel(
      title: object["title"],
      description: object["description"],
      assigner: object["assigner"],
      workspaceID: object["workspaceID"],
      due: object["due"],
      startTime: object["startTime"],
      createAt: object["createAt"],
      uid: object["uid"],
      state: object["state"],
      timeUpdate: object["timeUpdate"],
    );
  }

  Map<String, dynamic> ToMap() {
    return {
      "title": title,
      "description": description,
      "uid": uid,
      "assigner": assigner,
      "workspaceID": workspaceID,
      "createAt": createAt,
      "due": due,
      "startTime": startTime,
      "state": state,
      "timeUpdate": timeUpdate,
    };
  }
}
