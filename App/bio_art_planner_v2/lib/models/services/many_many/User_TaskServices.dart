import 'dart:convert';
import 'package:bio_art_planner_v2/models/services/UserServices.dart';

import '../../classes/Task.dart';
import '../../classes/User.dart';
import '../TaskServices.dart';
import '/models/classes/many_many/User_Task.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class UserTaskServices {

  final translator = GoogleTranslator();
  // om tasks op te halen
  Future getByUserId(int userId, [String language = "en", int limit = 0]) async {
    try {
      final url = 'http://192.168.20.3:8000/usertasks/$userId?limit=$limit';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final task = json.map((e) {
        return UserTask(
          userTasksId: e['userTasksId'],
          taskId: e['taskId'] ?? '',
          userId: e['userId'] ?? '',
          daily: e["daily"] ?? 0,
            createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null
        );
      }).toList();
      UserServices userServices = UserServices();
      TaskServices taskServices = TaskServices();
      late User user;
      List<Task> tasks = [];
      user = await userServices.getUserById(userId);
      print(user);
      for(var i = 0; i < task.length; i++){
        Task? taskToAdd = await taskServices.getTaskById(task[i].taskId);
        if(language != "en")
          {
            taskToAdd!.title = (await translator.translate(taskToAdd.title.toString(), from: "en", to: language)).text;
            taskToAdd.description = (await translator.translate(taskToAdd.description.toString(), from: "en", to: language)).text;
            if(taskToAdd.stockTypeString != null){
              taskToAdd.stockTypeString = (await translator.translate(taskToAdd.stockTypeString.toString(), from: "en", to: language)).text;
            }
            if(taskToAdd.taskTypeString != null){
              taskToAdd.taskTypeString = (await translator.translate(taskToAdd.taskTypeString.toString(), from: "en",  to: language)).text;
            }
          }
        tasks.add(taskToAdd!);
      }
      if (response.statusCode == 200) {
        return {
          "response": response.body,
          "user": user,
          "tasks": tasks
        };
      }
    } catch (e) {
      print(e);
    }
  }


  Future getByUserIdForToday(int userId, [String language = "en", limit]) async {
    try {
      final url = 'http://192.168.20.3:8000/usertasks/$userId/fortoday?limit=$limit';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;

      final userTasks = json.map((e) {
        return UserTask(
          userTasksId: e['userTasksId'],
          taskId: e['taskId'] ?? '',
          userId: e['userId'] ?? '',
          daily: e["daily"] ?? 0,
          createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null,
        );
      }).toList();

      UserServices userServices = UserServices();
      TaskServices taskServices = TaskServices();

      // Fetch user
      User user = await userServices.getUserById(userId);

      // Fetch all tasks sequentially and cast them correctly
      List<Task> tasks = [];
      for (var task in userTasks) {
        Task? fetchedTask = await taskServices.getTaskById(task.taskId);
        tasks.add(fetchedTask!);
      }

      // If translation is needed
      if (language != "en") {
        await Future.wait(tasks.map((task) async {
          task.title = (await translator.translate(task.title.toString(), from: "en", to: language)).text;
          task.description = (await translator.translate(task.description.toString(), from: "en", to: language)).text;

          if (task.stockTypeString != null) {
            task.stockTypeString = (await translator.translate(task.stockTypeString.toString(), from: "en", to: language)).text;
          }

          if (task.taskTypeString != null) {
            task.taskTypeString = (await translator.translate(task.taskTypeString.toString(), from: "en", to: language)).text;
          }
        }));
      }

      if (response.statusCode == 200) {
        return {
          "response": response.body,
          "user": user,
          "tasks": tasks,
        };
      }
    } catch (e) {
      print(e);
    }
  }


  //Om users op te halen
  Future getByTaskId(int taskId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasksusers/$taskId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final user = json.map((e) {
        return UserTask(
          userTasksId: e['userTasksId'],
          taskId: e['taskId'] ?? '',
          userId: e['userId'] ?? '',
          daily: e["daily"] ?? 0,
          createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null

        );
      }).toList();
      UserServices userServices = UserServices();
      List<User> users = [];
      for(var i = 0; i < user.length; i++){
        users.add(await userServices.getUserById(user[i].userId));
      }
      if (response.statusCode == 200) {
        return {
          "response": response.body,
          "users": users
        };
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeUserTask(UserTask userTask) async {
    try {
      const url = 'http://192.168.20.3:8000/usertasks/';
      final uri = Uri.parse(url);
      final body = {
          "userId": userTask.userId,
          "taskId": userTask.taskId,
          "daily": userTask.daily
      };
      final response = await http.post(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 201) {
        return response;
      } else {
        return "something went wrong";
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteUserTask(int userTaskId) async {
    try {
      final url = 'http://192.168.20.3:8000/usertasks/$userTaskId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editUserTask(UserTask userTask, int userTaskId) async {
    try {
      final url = 'http://192.168.20.3:8000/usertasks/$userTaskId';
      final uri = Uri.parse(url);
      final body = {
        "userId": userTask.userId,
        "taskId": userTask.taskId,
        "daily": userTask.daily
      };
      final response = await http.patch(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return print(true);
      }
    } catch (e) {
      print(e);
    }
  }
}
