import 'dart:convert';
import '/models/classes/TaskType.dart';
import "package:http/http.dart" as http;

class TaskTypeServices {
  Future<List<TaskType>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://192.168.20.3:8000/tasktypes';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final taskTypes = json.map((e) {
          return TaskType(taskTypeId: e["taskTypeId"], name: e['name']);
        }).toList();
        for (int i = 0; i < taskTypes.length; i++) {
          print(taskTypes[i].toJson());
        }
        return taskTypes;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<TaskType?> getTaskTypeById(int taskTypeId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasktype/$taskTypeId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the response is a single object, decode it directly
        final json = jsonDecode(response.body);
        final taskType =
            TaskType(taskTypeId: json["taskTypeId"], name: json["name"]);
        print(taskType); // Check the created TaskType object
        return taskType;
      }
    } catch (e) {
      print(e);
    }
    return null; // Return null if there is an error or the status code isn't 200
  }

  Future makeTaskType(TaskType taskType) async {
    try {
      const url = 'http://192.168.20.3:8000/tasktype/';
      final uri = Uri.parse(url);
      final body = {'name': taskType.name};
      print(body);
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

  Future deleteTaskType(int taskTypeId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasktype/$taskTypeId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editTaskType(TaskType taskType, int taskTypeId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasktype/$taskTypeId';
      final uri = Uri.parse(url);
      final body = {"name": taskType.name};
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
