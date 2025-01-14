import 'dart:convert';

import 'package:bioartlab_planner/models/classes/AnimalType.dart';
import 'package:bioartlab_planner/models/classes/Stock.dart';
import 'package:bioartlab_planner/models/classes/TaskType.dart';
import 'package:bioartlab_planner/models/services/AnimalServices.dart';
import 'package:bioartlab_planner/models/services/AnimalTypeServices.dart';
import 'package:bioartlab_planner/models/services/FoodTypeServices.dart';
import 'package:bioartlab_planner/models/services/StockServices.dart';
import 'package:bioartlab_planner/models/services/TaskServices.dart';
import 'package:bioartlab_planner/models/services/TaskTypeServices.dart';
import 'package:bioartlab_planner/models/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'classes/Animal.dart';
import 'classes/FoodType.dart';
import 'classes/Task.dart';
import 'classes/User.dart';

class GlobalProvider extends ChangeNotifier {
  bool isLoading = false;
  final _userService = UserServices();
  final _tasksService = TaskServices();
  final _stockServices = StockServices();
  final _animalServices = AnimalServices();
  final _taskTypeServices = TaskTypeServices();
  final _animalTypeServices = AnimalTypeServices();
  final _foodTypeServices = FoodTypeServices();
  late Map _currentUser = {};

  List<Task> _allTasks = [];
  List<Stock> _allStocks = [];
  List<Animal> _allAnimals = [];
  List<User> _allUsers = [];

  List<TaskType> _allTaskTypes = [];
  List<AnimalType> _allAnimalTypes = [];
  List<FoodType> _allFoodTypes = [];

  int _currentPageDrawer = 0;

  Map get currentUser => _currentUser;

  List<Task> get allTasks => _allTasks;

  List<Stock> get allStocks => _allStocks;

  List<Animal> get allAnimals => _allAnimals;
  List<User> get allUsers => _allUsers;


  List<TaskType> get allTaskTypes => _allTaskTypes;

  List<AnimalType> get allAnimalTypes => _allAnimalTypes;

  List<FoodType> get allFoodTypes => _allFoodTypes;

  int get currentPageDrawer => _currentPageDrawer;

  changePageDrawer(int index) {
    _currentPageDrawer = index;
    notifyListeners();
  }

  //User

  Future getAllUsers() async{
    isLoading = true;
    notifyListeners();

    final response = await _userService.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allUsers = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }



  Future<bool> createUser(User user) async {
    isLoading = true;
    notifyListeners();
    final response = await _userService.makeUser(user);
    getAllUsers();
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future deleteUser(int userId) async {
    isLoading = true;
    notifyListeners();
    final response = await _userService.deleteUser(userId);
    getAllUsers();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editUser(User user, int userId) async {
    isLoading = true;
    notifyListeners();
    final response = await _userService.editUser(user, userId);
    getAllUsers();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<bool> loginUser(User user) async {
    isLoading = true;
    notifyListeners();
    final url = 'http://127.0.0.1:8000/user/${user.username}';
    final uri = Uri.parse(url);
    final responseCheck = await http.get(uri);
    final userData = jsonDecode(responseCheck.body);

    final response = await _userService.loginUser(
        user.username.toString(), user.password.toString());
    if (response != null) {
      _currentUser = {
        "username": user.username,
        "function": userData["function"],
        "accessToken": response["access_token"],
        "tokenType": response["token_type"]
      };
      isLoading = false;
      notifyListeners();
      return true;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  //Task

  Future getAllTasks() async {
    isLoading = true;
    notifyListeners();

    final response = await _tasksService.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allTasks = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createTask(Task task) async {
    isLoading = true;
    notifyListeners();

    final response = await _tasksService.makeTask(task);
    getAllTasks();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteTask(int taskId) async {
    isLoading = true;
    notifyListeners();
    final response = await _tasksService.deleteTask(taskId);
    getAllTasks();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editTask(Task task, int taskId) async {
    isLoading = true;
    notifyListeners();
    final response = await _tasksService.editTask(task, taskId);
    getAllTasks();

    isLoading = false;
    notifyListeners();
    return response;
  }

//Stocks
  Future getAllStocks() async {
    isLoading = true;
    notifyListeners();

    final response = await _stockServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allStocks = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createStock(Stock stock) async {
    isLoading = true;
    notifyListeners();

    final response = await _stockServices.makeStock(stock);
    getAllStocks();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteStock(int stockId) async {
    isLoading = true;
    notifyListeners();
    final response = await _stockServices.deleteStock(stockId);
    getAllStocks();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editStock(Stock stock, int stockId) async {
    isLoading = true;
    notifyListeners();
    final response = await _stockServices.editStock(stock, stockId);
    getAllStocks();

    isLoading = false;
    notifyListeners();
    return response;
  }

  //Animals
  Future getAllAnimals() async {
    isLoading = true;
    notifyListeners();

    final response = await _animalServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allAnimals = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createAnimal(Animal animal) async {
    isLoading = true;
    notifyListeners();

    final response = await _animalServices.makeAnimal(animal);
    getAllAnimals();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteAnimal(int animalId) async {
    isLoading = true;
    notifyListeners();
    final response = await _animalServices.deleteAnimal(animalId);
    getAllAnimals();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editAnimal(Animal animal, int animalId) async {
    isLoading = true;
    notifyListeners();
    final response = await _animalServices.editAnimal(animal, animalId);
    getAllAnimals();

    isLoading = false;
    notifyListeners();
    return response;
  }

  //Types

//TaskTypes
  Future getAllTaskTypes() async {
    isLoading = true;
    notifyListeners();

    final response = await _taskTypeServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allTaskTypes = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createTaskType(TaskType taskType) async {
    isLoading = true;
    notifyListeners();

    final response = await _taskTypeServices.makeTaskType(taskType);
    getAllTaskTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteTaskType(int taskTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _taskTypeServices.deleteTaskType(taskTypeId);
    getAllTaskTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editTaskType(TaskType taskType, int taskTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _taskTypeServices.editTaskType(taskType, taskTypeId);
    getAllTaskTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  // Animal types

  Future getAllAnimalTypes() async {
    isLoading = true;
    notifyListeners();

    final response = await _animalTypeServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allAnimalTypes = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createAnimalType(AnimalType animalType) async {
    isLoading = true;
    notifyListeners();

    final response = await _animalTypeServices.makeAnimalType(animalType);
    getAllAnimalTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteAnimalType(int animalTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _animalTypeServices.deleteAnimalType(animalTypeId);
    getAllAnimalTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editAnimalType(AnimalType animalType, int animalTypeId) async {
    isLoading = true;
    notifyListeners();
    final response =
        await _animalTypeServices.editAnimalType(animalType, animalTypeId);
    getAllAnimalTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  //Food types
  Future getAllFoodTypes() async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      _allFoodTypes = response;

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createFoodType(FoodType foodType) async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeServices.makeFoodType(foodType);
    getAllFoodTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteFoodType(int foodTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _foodTypeServices.deleteFoodType(foodTypeId);
    getAllFoodTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editFoodType(FoodType foodType, int foodTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _foodTypeServices.editFoodType(foodType, foodTypeId);
    getAllFoodTypes();

    isLoading = false;
    notifyListeners();
    return response;
  }
}
