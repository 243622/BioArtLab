import 'dart:convert';
import 'package:bioartlab_planner/models/classes/Task.dart';
import 'package:bioartlab_planner/models/services/TaskTypeServices.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  Future<List<Task>> getAll([limit, offset, done, taskType]) async {
    try {
      // ddsda
      TaskTypeServices _taskTypeServices = TaskTypeServices();
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (done != null) 'done': done.toString(),
        if (taskType != null) 'taskType': taskType.toString()
      };
      const url = 'http://127.0.0.1:8000/tasks';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final tasks = json.map((e) {
          return Task(
            taskId: e['taskId'],
            title: e['title'] ?? '',
            // Provide a default value or handle null safely
            description: e['description'] ?? '',
            priority: e['priority'] ?? 0,
            // Default priority to 0 if null
            taskType: e['taskType'] ?? 0,
            finished: e['finished'] ?? 0,
            doneDate:
                e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
            // Parse if not null
            deadline:
                e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
            // Parse if not null
            stockId: e['stockId'],
            quantity: e['quantity'] ?? 0, // Default quantity to 0 if null
          );
        }).toList();
        for (int i = 0; i < tasks.length; i++) {
          var responseToDecode =
              await _taskTypeServices.getTaskTypeById(tasks[i].taskType!);
          tasks[i].taskTypeString = responseToDecode?.name.toString();
        }
        return tasks;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future getTaskById(int taskId) async {
    try {
      final url = 'http://127.0.0.1:8000/task/${taskId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final task = json.map((e) {
        return Task(
          taskId: e['taskId'],
          title: e['title'] ?? '',
          description: e['description'] ?? '',
          priority: e['priority'] ?? 0,
          taskType: e['taskType'] ?? 0,
          finished: e['finished'],
          doneDate:
              e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
          deadline:
              e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
          stockId: e['stockId'],
          quantity: e['quantity'] ?? 0,
        );
      }).toList();
      if (response.statusCode == 200) {
        return task;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeTask(Task task) async {
    try {
      const url = 'http://127.0.0.1:8000/task/';
      final uri = Uri.parse(url);
      final body = {
        "title": task.title,
        "description": task.description,
        "priority": task.priority,
        'taskType': task.taskType,
        'finished': task.finished,
        'deadline': task.deadline?.toIso8601String(),
        'stockId': task.stockId,
        'quantity': task.quantity
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

  Future deleteTask(int taskId) async {
    try {
      final url = 'http://127.0.0.1:8000/tasks/${taskId}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editTask(Task task, int taskId) async {
    try {
      final url = 'http://127.0.0.1:8000/task/${taskId}';
      final uri = Uri.parse(url);
      final body = {
        "title": task.title,
        "description": task.description,
        "priority": task.priority,
        'taskType': task.taskType,
        'finished': task.finished,
        'deadline': task.deadline?.toIso8601String(),
        'stockId': task.stockId,
        'quantity': task.quantity
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
