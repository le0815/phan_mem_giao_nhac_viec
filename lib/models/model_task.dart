class ModelTask {
  final String titleTask;
  final String descriptionTask;

  ModelTask({required this.titleTask, required this.descriptionTask});

  Map<String, dynamic> ToMap() {
    return {
      "title": titleTask,
      "description": descriptionTask,
    };
  }
}
