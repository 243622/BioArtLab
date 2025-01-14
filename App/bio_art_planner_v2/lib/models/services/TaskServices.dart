import 'dart:convert';
import 'package:bio_art_planner_v2/models/services/AnimalTypeServices.dart';
import 'package:bio_art_planner_v2/models/services/FoodTypeServices.dart';
import 'package:bio_art_planner_v2/models/services/StockServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/User_TaskServices.dart';
import 'package:intl/intl.dart';

import '/models/classes/Task.dart';
import '/models/services/TaskTypeServices.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  TaskTypeServices taskTypeServices = TaskTypeServices();
  FoodTypeServices foodTypeServices = FoodTypeServices();
  StockServices stockServices = StockServices();
  UserTaskServices userTaskServices = UserTaskServices();
  AnimalTypeServices animalTypeServices = AnimalTypeServices();
  Future<List<Task>> getAll([limit, offset, done, taskType, priority, daily]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (done != null) 'done': done.toString(),
        if (taskType != null) 'taskType': taskType.toString(),
        if(priority != null) "priority": priority.toString(),
        if(daily != null) "daily" : daily.toString()
      };
      const url = 'http://192.168.20.3:8000/tasks';
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
            taskType: e['taskType'] ?? null,
            finished: e['finished'] ?? 0,
            doneDate:
            e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
            // Parse if not null
            deadline:
            e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
            createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null,
            // Parse if not null
            stockId: e['stockId'],
            quantity: e['quantity'] ?? 0,
            daily: e["daily"] ?? 0,
              rapportId: e["rapportId"] ?? null,
            animalTypeId: e["animalTypeId"] ?? null

            // Default quantity to 0 if null
          );
        }).toList();

        //var futures = <Future>[];

        for (int i = 0; i < tasks.length; i++) {
          // Introduce a 1-second delay before awaiting Future.wait

          // Create a list of futures to wait on, dynamically include them if they are not null
          List<Future> futures = [];
          if (tasks[i].taskType != null) futures.add(taskTypeServices.getTaskTypeById(tasks[i].taskType!));
          if (tasks[i].stockId != null) futures.add(stockServices.getStockById(tasks[i].stockId!));
          if (tasks[i].animalTypeId != null) futures.add(animalTypeServices.getAnimalTypeById(tasks[i].animalTypeId!));
          futures.add(userTaskServices.getByTaskId(tasks[i].taskId!));

          // Wait for all the futures to complete
          var results = await Future.wait(futures);

          // Check the results in the same order as the futures were added to the list
          int resultIndex = 0;

          // Check and assign taskType
          if (tasks[i].taskType != null && resultIndex < results.length) {
            var responseToDecode = results[resultIndex];
            tasks[i].taskTypeString = responseToDecode?.name.toString();
            resultIndex++;
          }

          // Check and assign stockType
          if (tasks[i].stockId != null && resultIndex < results.length) {
            var responseToStock = results[resultIndex];
            var responseToDecodeV = await foodTypeServices.getFoodTypeById(responseToStock.foodTypeId);
            tasks[i].stockTypeString = responseToDecodeV?.name;
            resultIndex++;
          }

          // Check and assign animalType
          if (tasks[i].animalTypeId != null && resultIndex < results.length) {
            var responseToAnimalType = results[resultIndex];
            tasks[i].animalTypeInString = responseToAnimalType?.name;
            resultIndex++;
          }

          // Always assign usersForTask
          var usersForTask = results[resultIndex];
          tasks[i].users = usersForTask["users"];
        }
        return tasks;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<List<Task>> getAllByDate(DateTime date, [limit, offset, done, taskType, priority]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (done != null) 'done': done.toString(),
        if (taskType != null) 'taskType': taskType.toString(),
        if(priority != null) "priority": priority.toString(),
        "date": DateFormat("yyyy-MM-dd").format(date)
      };
      const url = 'http://192.168.20.3:8000/tasksbydate';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final tasks = json.map((e) {
          return Task(
            taskId: e['taskId'],
            title: e['title'] ?? '',
            description: e['description'] ?? '',
            priority: e['priority'] ?? 0,
            taskType: e['taskType'] ?? null,
            finished: e['finished'] ?? 0,
            doneDate: e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
            deadline: e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
            createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null,
            stockId: e['stockId'],
            quantity: e['quantity'] ?? 0,
            daily: e["daily"] ?? 0,
            rapportId: e["rapportId"] ?? null,
            animalTypeId: e["animalTypeId"] ?? null,
          );
        }).toList();

        for (int i = 0; i < tasks.length; i++) {
          // Introduce a 1-second delay before awaiting Future.wait

          // Create a list of futures to wait on, dynamically include them if they are not null
          List<Future> futures = [];
          if (tasks[i].taskType != null) futures.add(taskTypeServices.getTaskTypeById(tasks[i].taskType!));
          if (tasks[i].stockId != null) futures.add(stockServices.getStockById(tasks[i].stockId!));
          if (tasks[i].animalTypeId != null) futures.add(animalTypeServices.getAnimalTypeById(tasks[i].animalTypeId!));
          futures.add(userTaskServices.getByTaskId(tasks[i].taskId!));

          // Wait for all the futures to complete
          var results = await Future.wait(futures);

          // Check the results in the same order as the futures were added to the list
          int resultIndex = 0;

          // Check and assign taskType
          if (tasks[i].taskType != null && resultIndex < results.length) {
            var responseToDecode = results[resultIndex];
            tasks[i].taskTypeString = responseToDecode?.name.toString();
            resultIndex++;
          }

          // Check and assign stockType
          if (tasks[i].stockId != null && resultIndex < results.length) {
            var responseToStock = results[resultIndex];
            var responseToDecodeV = await foodTypeServices.getFoodTypeById(responseToStock.foodTypeId);
            tasks[i].stockTypeString = responseToDecodeV?.name;
            resultIndex++;
          }

          // Check and assign animalType
          if (tasks[i].animalTypeId != null && resultIndex < results.length) {
            var responseToAnimalType = results[resultIndex];
            tasks[i].animalTypeInString = responseToAnimalType?.name;
            resultIndex++;
          }

          // Always assign usersForTask
          var usersForTask = results[resultIndex];
          tasks[i].users = usersForTask["users"];
        }

        return tasks;

      }
    } catch (e) {
      print(e);
    }

    return [];
  }


  Future<List<Task>> getAllByDaily([limit, offset, done, taskType, priority]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (done != null) 'done': done.toString(),
        if (taskType != null) 'taskType': taskType.toString(),
        if(priority != null) "priority": priority.toString(),
      };
      const url = 'http://192.168.20.3:8000/tasksbydaily';
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
              taskType: e['taskType'] ?? null,
              finished: e['finished'] ?? 0,
              doneDate:
              e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
              // Parse if not null
              deadline:
              e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
              createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null,
              // Parse if not null
              stockId: e['stockId'],
              quantity: e['quantity'] ?? 0,
              daily: e["daily"] ?? 0,
              rapportId: e["rapportId"] ?? null,
              animalTypeId: e["animalTypeId"] ?? null

            // Default quantity to 0 if null
          );
        }).toList();
        for (int i = 0; i < tasks.length; i++) {
          // Introduce a 1-second delay before awaiting Future.wait

          // Create a list of futures to wait on, dynamically include them if they are not null
          List<Future> futures = [];
          if (tasks[i].taskType != null) futures.add(taskTypeServices.getTaskTypeById(tasks[i].taskType!));
          if (tasks[i].stockId != null) futures.add(stockServices.getStockById(tasks[i].stockId!));
          if (tasks[i].animalTypeId != null) futures.add(animalTypeServices.getAnimalTypeById(tasks[i].animalTypeId!));
          futures.add(userTaskServices.getByTaskId(tasks[i].taskId!));

          // Wait for all the futures to complete
          var results = await Future.wait(futures);

          // Check the results in the same order as the futures were added to the list
          int resultIndex = 0;

          // Check and assign taskType
          if (tasks[i].taskType != null && resultIndex < results.length) {
            var responseToDecode = results[resultIndex];
            tasks[i].taskTypeString = responseToDecode?.name.toString();
            resultIndex++;
          }

          // Check and assign stockType
          if (tasks[i].stockId != null && resultIndex < results.length) {
            var responseToStock = results[resultIndex];
            var responseToDecodeV = await foodTypeServices.getFoodTypeById(responseToStock.foodTypeId);
            tasks[i].stockTypeString = responseToDecodeV?.name;
            resultIndex++;
          }

          // Check and assign animalType
          if (tasks[i].animalTypeId != null && resultIndex < results.length) {
            var responseToAnimalType = results[resultIndex];
            tasks[i].animalTypeInString = responseToAnimalType?.name;
            resultIndex++;
          }

          // Always assign usersForTask
          var usersForTask = results[resultIndex];
          tasks[i].users = usersForTask["users"];
        }
        return tasks;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }



  Future<Task?> getTaskById(int taskId) async {
    try {
      final url = 'http://192.168.20.3:8000/task/$taskId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        return null; // Return null if the response is not successful.
      }

      final json = jsonDecode(response.body);
      final task = Task(
        taskId: json['taskId'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        priority: json['priority'] ?? 0,
        taskType: json['taskType'],
        finished: json['finished'] ?? 0,
        doneDate: json['doneDate'] != null ? DateTime.parse(json['doneDate']) : null,
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        createdDate: json["createdDate"] != null ? DateTime.parse(json["createdDate"]) : null,
        stockId: json['stockId'],
        quantity: json['quantity'] ?? 0,
        daily: json["daily"] ?? 0,
        rapportId: json["rapportId"],
        animalTypeId: json["animalTypeId"],
      );

      // Parallel fetching of related data
      await Future.wait([
        if (task.taskType != null)
          taskTypeServices.getTaskTypeById(task.taskType!).then((response) {
            task.taskTypeString = response?.name;
          }),
        if (task.stockId != null)
          stockServices.getStockById(task.stockId!).then((responseToStock) async {
            if (responseToStock?.foodTypeId != null) {
              final foodTypeResponse = await foodTypeServices.getFoodTypeById(responseToStock!.foodTypeId);
              task.stockTypeString = foodTypeResponse?.name;
            }
          }),
        if (task.animalTypeId != null)
          animalTypeServices.getAnimalTypeById(task.animalTypeId!).then((responseToAnimalType) {
            task.animalTypeInString = responseToAnimalType.name;
          }),
        userTaskServices.getByTaskId(task.taskId!).then((usersForTask) {
          task.users = usersForTask["users"];
        }),
      ]);

      return task;
    } catch (e) {
      print("Error fetching task by ID: $e");
      return null;
    }
  }


  Future getTasksByRapportId(int rapportId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasksbyrapportid/$rapportId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final tasks = json.map((e) {
        return Task(
            taskId: e['taskId'],
            title: e['title'] ?? '',
            // Provide a default value or handle null safely
            description: e['description'] ?? '',
            priority: e['priority'] ?? 0,
            // Default priority to 0 if null
            taskType: e['taskType'] ?? null,
            finished: e['finished'] ?? 0,
            doneDate:
            e['doneDate'] != null ? DateTime.parse(e['doneDate']) : null,
            // Parse if not null
            deadline:
            e['deadline'] != null ? DateTime.parse(e['deadline']) : null,
            createdDate: e["createdDate"] != null ? DateTime.parse(e["createdDate"]) : null,
            // Parse if not null
            stockId: e['stockId'],
            quantity: e['quantity'] ?? 0,
            daily: e["daily"] ?? 0,
            rapportId: e["rapportId"] ?? null,
            animalTypeId: e["animalTypeId"] ?? null

          // Default quantity to 0 if null
        );
      }).toList();
      for (int i = 0; i < tasks.length; i++) {
        // Introduce a 1-second delay before awaiting Future.wait

        // Create a list of futures to wait on, dynamically include them if they are not null
        List<Future> futures = [];
        if (tasks[i].taskType != null) futures.add(taskTypeServices.getTaskTypeById(tasks[i].taskType!));
        if (tasks[i].stockId != null) futures.add(stockServices.getStockById(tasks[i].stockId!));
        if (tasks[i].animalTypeId != null) futures.add(animalTypeServices.getAnimalTypeById(tasks[i].animalTypeId!));
        futures.add(userTaskServices.getByTaskId(tasks[i].taskId!));

        // Wait for all the futures to complete
        var results = await Future.wait(futures);

        // Check the results in the same order as the futures were added to the list
        int resultIndex = 0;

        // Check and assign taskType
        if (tasks[i].taskType != null && resultIndex < results.length) {
          var responseToDecode = results[resultIndex];
          tasks[i].taskTypeString = responseToDecode?.name.toString();
          resultIndex++;
        }

        // Check and assign stockType
        if (tasks[i].stockId != null && resultIndex < results.length) {
          var responseToStock = results[resultIndex];
          var responseToDecodeV = await foodTypeServices.getFoodTypeById(responseToStock.foodTypeId);
          tasks[i].stockTypeString = responseToDecodeV?.name;
          resultIndex++;
        }

        // Check and assign animalType
        if (tasks[i].animalTypeId != null && resultIndex < results.length) {
          var responseToAnimalType = results[resultIndex];
          tasks[i].animalTypeInString = responseToAnimalType?.name;
          resultIndex++;
        }

        // Always assign usersForTask
        var usersForTask = results[resultIndex];
        tasks[i].users = usersForTask["users"];
      }
      return tasks;
      } catch (e) {
      print(e);
    }
  }

  Future makeTask(Task task) async {
    try {
      const url = 'http://192.168.20.3:8000/task/';
      final uri = Uri.parse(url);
      final body = {
        "title": task.title,
        "description": task.description,
        "priority": task.priority,
        'taskType': task.taskType,
        'finished': task.finished,
        'deadline': task.deadline?.toIso8601String(),
        'stockId': task.stockId,
        'quantity': task.quantity,
        'daily': task.daily,
        'rapportId': task.rapportId,
        "animalTypeId": task.animalTypeId
      };
      final response = await http.post(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 201) {
        var taskToDecode = jsonDecode(response.body);
        Task task = Task(
          taskId: taskToDecode['taskId'],
          title: taskToDecode['title'] ?? '',
          description: taskToDecode['description'] ?? '',
          priority: taskToDecode['priority'] ?? 0,
          taskType: taskToDecode['taskType'],
          finished: taskToDecode['finished'] ?? 0,
          doneDate: taskToDecode['doneDate'] != null ? DateTime.parse(taskToDecode['doneDate']) : null,
          deadline: taskToDecode['deadline'] != null ? DateTime.parse(taskToDecode['deadline']) : null,
          createdDate: taskToDecode["createdDate"] != null ? DateTime.parse(taskToDecode["createdDate"]) : null,
          stockId: taskToDecode['stockId'],
          quantity: taskToDecode['quantity'] ?? 0,
          daily: taskToDecode["daily"] ?? 0,
          rapportId: taskToDecode["rapportId"],
          animalTypeId: taskToDecode["animalTypeId"],
        );
        return task;
      } else {
        return "something went wrong";
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteTask(int taskId) async {
    try {
      final url = 'http://192.168.20.3:8000/tasks/$taskId';
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
      final url = 'http://192.168.20.3:8000/task/$taskId';
      final uri = Uri.parse(url);
      final body = {
        "title": task.title,
        "description": task.description,
        "priority": task.priority,
        'taskType': task.taskType,
        'finished': task.finished,
        'deadline': task.deadline?.toIso8601String(),
        'stockId': task.stockId,
        'quantity': task.quantity,
        'daily': task.daily,
        'rapportId': task.rapportId,
        "animalTypeId": task.animalTypeId,

      };
      final response = await http.patch(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonTask = json.decode(response.body);

        final task = Task(
            taskId: jsonTask['taskId'],
            title: jsonTask['title'] ?? '',
            description: jsonTask['description'] ?? '',
            priority: jsonTask['priority'] ?? 0,
            taskType: jsonTask['taskType'] ?? null,
            finished: jsonTask['finished'] ?? 0,
            doneDate:
            jsonTask['doneDate'] != null ? DateTime.parse(jsonTask['doneDate']) : null,
            deadline:
            jsonTask['deadline'] != null ? DateTime.parse(jsonTask['deadline']) : null,
            createdDate: jsonTask["createdDate"] != null ? DateTime.parse(jsonTask["createdDate"]) : null,

            stockId: jsonTask['stockId'],
            quantity: jsonTask['quantity'] ?? 0,
            daily: jsonTask["daily"] ?? 0,
            rapportId: jsonTask["rapportId"] ?? null,
            animalTypeId: jsonTask["animalTypeId"] ?? null
        );
        if(task.taskType != null){
          var responseToDecode = await taskTypeServices.getTaskTypeById(task.taskType!);
          task.taskTypeString = responseToDecode?.name.toString();
        }
        if(task.stockId != null){
          var responseToStock = await stockServices.getStockById(task.stockId!);
          var responseToDecodeV = await foodTypeServices.getFoodTypeById(responseToStock?.foodTypeId);
          task.stockTypeString = responseToDecodeV?.name;
        }
        if(task.animalTypeId != null){
          var responseToAnimalType = await animalTypeServices.getAnimalTypeById(task.animalTypeId!);
          task.animalTypeInString = responseToAnimalType.name;
        }
        var usersForTask = await userTaskServices.getByTaskId(task.taskId!);
        task.users = usersForTask["users"];
        return task;
      }
    } catch (e) {
      print(e);
    }
  }
}
