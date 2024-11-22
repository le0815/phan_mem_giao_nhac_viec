class ModelTask {
  String titleTask;
  String descriptionTask;
  final String uid;
  final String? idTask;

  ModelTask({
    required this.titleTask,
    required this.descriptionTask,
    required this.uid,
    this.idTask,
  });

  Map<String, dynamic> ToMap() {
    return (idTask == null)
        ? {
            "title": titleTask,
            "description": descriptionTask,
            "uid": uid,
          }
        : {
            "title": titleTask,
            "description": descriptionTask,
            "uid": uid,
            "idTask": idTask
          };
  }
}
