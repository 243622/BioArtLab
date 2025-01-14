class Task{
  late int? taskId;
  late String? title;
  late String? description;
  late int? priority;
  late int? taskType;
  late int? finished;
  late DateTime? createDate;
  late DateTime? doneDate;
  late DateTime? deadline;
  late int? stockId;
  late int? quantity;
  late String? taskTypeString;

  Task({
   this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    this.taskType,
    this.finished,
    this.createDate,
    this.doneDate,
    this.deadline,
    this.stockId,
    this.quantity,
    this.taskTypeString
});

  Map<String, dynamic> toJson(){
    return {
      "TaskId": taskId,
      "Title": title,
      "Description": description,
      "Priority": priority,
      'taskType': taskType,
      'finished': finished,
      'doneDate': doneDate,
      'deadline': deadline,
      'stockId': stockId,
      'quantity': quantity,
      "type in string": taskTypeString
    };
  }
}