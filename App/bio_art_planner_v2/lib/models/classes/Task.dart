class Task{
  late int? taskId;
  late String? title;
  late String? description;
  late int? priority;
  late int? taskType;
  late int? finished;
  late DateTime? createdDate;
  late DateTime? doneDate;
  late DateTime? deadline;
  late int? stockId;
  late int? quantity;
  late int? daily;
  late int? rapportId;
  late int? animalTypeId;
  late String? taskTypeString;
  late String? stockTypeString;
  late String? animalTypeInString;
  late List? users = [];

  Task({
   this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    this.taskType,
    this.finished,
    this.createdDate,
    this.doneDate,
    this.deadline,
    this.stockId,
    this.quantity,
    this.daily,
    this.taskTypeString,
    this.stockTypeString,
    this.animalTypeInString,
    this.users,
    this.rapportId,
    this.animalTypeId
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
      "daily": daily,
      "type in string": taskTypeString,
      "stock type in string": stockTypeString,
      "users": users,
      "rapportId": rapportId,
      "animalTypeId": animalTypeId,
      "animalTypeInString": animalTypeInString
    };
  }
}