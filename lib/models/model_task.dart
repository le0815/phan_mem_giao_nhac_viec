class ModelTask {
  final String titleTask;
  final String descriptionTask;
  final String uid;

  ModelTask({
    required this.titleTask,
    required this.descriptionTask,
    required this.uid,
  });

  Map<String, dynamic> ToMap() {
    return {"title": titleTask, "description": descriptionTask, "uid": uid};
  }
}
