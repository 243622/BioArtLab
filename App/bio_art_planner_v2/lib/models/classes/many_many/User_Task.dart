class UserTask{
  late int? userTasksId;
  late int userId;
  late int taskId;
  late int? daily;
  late DateTime? createdDate;

  UserTask({
    this.userTasksId,
    required this.userId,
    required this.taskId,
    this.daily,
    this.createdDate
});

  Map<String, dynamic> toJson(){
    return {
      "userTaskId": userTasksId,
      "userId": userId,
      "taskId": taskId,
      "daily": daily,
      "createdDate": createdDate
    };
  }
}