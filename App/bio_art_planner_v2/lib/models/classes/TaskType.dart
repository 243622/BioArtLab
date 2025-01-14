class TaskType{
  late int? taskTypeId;
  late String name;

  TaskType({
    this.taskTypeId,
    required this.name
});

  Map<String, dynamic> toJson(){
    return {
      "tasktypeid": taskTypeId,
      "name": name
    };
  }
}