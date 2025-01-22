import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/many_many/Foodtype_Animal.dart';
import 'package:bio_art_planner_v2/models/classes/many_many/User_Task.dart';
import 'package:bio_art_planner_v2/models/services/RapportServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/Foodtype_AnimalServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/User_TaskServices.dart';

import '/models/classes/AnimalType.dart';
import '/models/classes/Stock.dart';
import '/models/classes/TaskType.dart';
import '/models/services/AnimalServices.dart';
import '/models/services/AnimalTypeServices.dart';
import '/models/services/FoodTypeServices.dart';
import '/models/services/StockServices.dart';
import '/models/services/TaskServices.dart';
import '/models/services/TaskTypeServices.dart';
import '/models/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'classes/Animal.dart';
import 'classes/FoodType.dart';
import 'classes/Rapport.dart';
import 'classes/Task.dart';
import 'classes/User.dart';

class GlobalProvider extends ChangeNotifier {
  bool isLoading = false;
  //Base
  final _userService = UserServices();
  final _tasksService = TaskServices();
  final _stockServices = StockServices();
  final _animalServices = AnimalServices();
  final _rapportServices = RapportServices();
  //Types
  final _taskTypeServices = TaskTypeServices();
  final _animalTypeServices = AnimalTypeServices();
  final _foodTypeServices = FoodTypeServices();

  //Many
  final _userTaskServices = UserTaskServices();
  final _foodTypeAnimalTypeServices = FoodTypeAnimalServices();

  //To delete before release
  final localHostUrl = "http://127.0.0.1:8000";
  final localHostUrlEmulator = "http://10.0.2.2:8000";
  final releaseHostUrl = "http://192.168.20.3:8000";
  static const String _baseApi = 'http://10.0.2.2:8000';


  late Map _currentUser = {};


  //Base
  List<Task> _allTasks = [];
  List<Task> _allTasksForRapports = [];
  List<Stock> _allStocks = [];
  List<Animal> _allAnimals = [];
  List<User> _allUsers = [];
  List<Rapport> _allRapports = [];
  List<Rapport> _rapportsForToday = [];


  //Types
  List<TaskType> _allTaskTypes = [];
  List<AnimalType> _allAnimalTypes = [];
  List<FoodType> _allFoodTypes = [];

  //Filters
  List<Task> _tasksByDay = [];
  List<Task> _tasksByDaily = [];

  //Many
  List<Task> _allUserTasks = [];
  List<User> _allTaskUsers = [];
  final List<FoodtypeAnimal> _allFoodTypesAnimal = [];
  List<FoodtypeAnimal> _allAnimalTypesFoodType = [];

  //Selected
  Map _selectedPriority = {};
  Map _selectedTaskType = {};
  Map _selectedAnimalType = {};
  Map _selectedStock = {};
  int _selectedQuantity = 0;
  final List _selectedUsers = [];
  DateTime? _selectedDate;
  int? _selectedFunction;
  String _selectedFilter = "";
  String _selectedFilterChoice = "";
  bool _isSelectedDaily = false;
  bool _isSelectedFinished = false;
  final List _selectedAnimalTypes = [];
  final List _selectedFoodTypes = [];

  int _currentPageDrawer = 0;

  String _usersLanguage = "en";

  Map get currentUser => _currentUser;

  //Base
  List<Task> get allTasks => _allTasks;
  List<Task> get allTasksForRapports => _allTasksForRapports;
  List<Stock> get allStocks => _allStocks;
  List<Animal> get allAnimals => _allAnimals;
  List<User> get allUsers => _allUsers;
  List<Rapport> get allRapports => _allRapports;
  List<Rapport> get rapportsForToday => _rapportsForToday;


  //Filters
  List<Task> get tasksByDay => _tasksByDay;
  List<Task> get tasksByDaily => _tasksByDaily;
  //Types
  List<TaskType> get allTaskTypes => _allTaskTypes;
  List<AnimalType> get allAnimalTypes => _allAnimalTypes;
  List<FoodType> get allFoodTypes => _allFoodTypes;

  String get usersLanguage => _usersLanguage;

  //Many
  List<Task> get allUserTasks => _allUserTasks;
  List<User> get allTaskUsers => _allTaskUsers;
  List<FoodtypeAnimal> get allFoodTypesAnimal => _allFoodTypesAnimal;
  List<FoodtypeAnimal> get allAnimalTypesFoodType => _allAnimalTypesFoodType;

  //Selected
  Map get selectedPriority => _selectedPriority;
  Map get selectedTaskType => _selectedTaskType;
  Map get selectedStock => _selectedStock;
  Map get selectedAnimalType => _selectedAnimalType;
  int get selectedQuantity => _selectedQuantity;
  List get selectedUsers => _selectedUsers;
  DateTime? get selectedDate => _selectedDate;
  int? get selectedFunction => _selectedFunction;
  String get selectedFilter => _selectedFilter;
  String get selectedFilterChoice => _selectedFilterChoice;
  bool get isSelectedDaily => _isSelectedDaily;
  bool get isSelectedFinished => _isSelectedFinished;
  List get selectedAnimalTypes => _selectedAnimalTypes;
  List get selectedFoodTypes => _selectedFoodTypes;



  //Other

  //Hardcoded lists
  List<Map> priorities = [
    {
      "value": 1,
      "label": "Priority - not so important"
    },
    {
      "value": 2,
      "label": "Priority - important"
    }
  ];
  List<Map> userFunctions = [
    {
      "value": 0,
      "label": "User"
    },
    {
      "value": 1,
      "label": "Admin"
    }
  ];
  List<String> filterChoices = [
    "Alle tasks",
    "Filter by user",
    "Filter by finished",
    "Filter by priority"
  ];

  int get currentPageDrawer => _currentPageDrawer;

  changePageDrawer(int index) {
    _currentPageDrawer = index;
    notifyListeners();
  }

  //User
  Future getAllUsers() async{
    isLoading = true;
    final response = await _userService.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      _allUsers = response;
      notifyListeners();
      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future getUserById(int userId) async {
    isLoading = true;

    final response = await _userService.getUserById(userId);
    if (response != null) {
      isLoading = false;
      notifyListeners();

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
    final url = '$_baseApi/user/${user.username}';
    final uri = Uri.parse(url);
    final responseCheck = await http.get(uri);
    if(responseCheck.statusCode == 401){
      return false;
    }
    final userData = jsonDecode(responseCheck.body);

    final response = await _userService.loginUser(
        user.username.toString(), user.password.toString());
    if (response != null) {
      _currentUser = {
        "userId": userData["userId"],
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

  Future getAllTasks([limit, offset, done, taskType, priority]) async {
    try{
      isLoading = true;

      final response = await _tasksService.getAll(limit, offset, done, taskType, priority);
      if (response.isNotEmpty) {
        isLoading = false;
        _allTasks = response;
        notifyListeners();

        return response;
      }
      isLoading = false;
      notifyListeners();
      return [];
    }
    catch(e){
      print(e);
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
    return [];
  }
  Future getTasksByDate(DateTime date, [limit]) async {
    try {
      isLoading = true;

      // Fetch all tasks

      // List<Task> tasksToReturn = allTasks.where((e) {
      //   return e.createdDate != null &&
      //       DateFormat('yyyy-MM-dd').format(e.createdDate!) ==
      //           DateFormat('yyyy-MM-dd').format(date);
      // }).toList();

      _tasksByDay = await _tasksService.getAllByDate(date, limit);
      isLoading = false;
      notifyListeners();
      return _tasksByDay; // Return the filtered list
    } catch (e) {
      print('Error in getTasksByDate: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Ensure the UI updates even on error
    }
    return [];

  }

  Future getTasksByDaily([limit]) async{
    try{
      isLoading = true;
      _tasksByDaily = await _tasksService.getAll(limit, null , null , null ,null, 1);
      isLoading = false;
      notifyListeners();
      return _tasksByDaily;
    }
    catch(e){
      print(e);
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
    return [];
  }




  Future getTaskById(int taskId) async {
    isLoading = true;
    notifyListeners();

    final response = await _tasksService.getTaskById(taskId);
    if (response != null) {
      isLoading = false;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getTasksByRapportId(int rapportId) async {
    isLoading = true;

    final response = await _tasksService.getTasksByRapportId(rapportId);
    if (response != null) {
      isLoading = false;
      _allTasksForRapports = response;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createTask(Task task) async {
    isLoading = true;

    final response = await _tasksService.makeTask(task);
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteTask(int taskId, String taskList) async {

    // Call the backend to delete the task
    final response = await _tasksService.deleteTask(taskId);

    // Remove the task locally from the task list
    if (response != null) {
      // Assuming your tasks are stored in a list like _allTasks
      if(taskList == "tasksByDay") _tasksByDay.removeWhere((task) => task.taskId == taskId);
      if(taskList == "allTasks") _allTasks.removeWhere((task) => task.taskId == taskId);
      if(taskList == "tasksByDaily") _tasksByDaily.removeWhere((task) => task.taskId == taskId);
      // Optionally: you can also remove the task from any other relevant lists
      // (such as grouped lists or filtered lists) depending on your use case.

      isLoading = false;
      cleanSelected();
      cleanSelectedUsers();
      notifyListeners();  // Notify listeners to update the UI
    }

    return response;
  }


  Future editTask(Task task, int taskId) async {
    isLoading = true;
    final response = await _tasksService.editTask(task, taskId);

    isLoading = false;
    notifyListeners();
    return response;
  }

  void updateTask(Task updatedTask, String taskList) {
    List<Task> taskListToUpdate = [];
    if(taskList == "tasksByDay") taskListToUpdate = _tasksByDay;
    if(taskList == "allTasks") taskListToUpdate = _allTasks;
    if(taskList == "tasksByDaily") taskListToUpdate = _tasksByDaily;
    int index = taskListToUpdate.indexWhere((task) => task.taskId == updatedTask.taskId);
    if (index != -1) {
      taskListToUpdate[index] = updatedTask;
      notifyListeners();  // Notify listeners to refresh the UI
    }
  }

//Stocks
  Future getAllStocks([limit]) async {
    isLoading = true;


    final response = await _stockServices.getAll(limit);
    if (response.isNotEmpty) {
      isLoading = false;
      _allStocks = response;

      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future getStockById(int stockId) async {
    isLoading = true;
    notifyListeners();

    final response = await _stockServices.getStockById(stockId);
    if (response != null) {
      setSelectedStock({
        "stockId": response.stockId,
        "quantity": response.quantity,
        "minimumQuantity": response.minimumQuantity,
        "foodTypeId": response.foodTypeId,
        "foodTypeInString": response.foodTypeInString
      });
      isLoading = false;

      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createStock(Stock stock) async {
    isLoading = true;

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
  Future getAllAnimals([limit]) async {
    isLoading = true;

    final response = await _animalServices.getAll(limit);
    if (response.isNotEmpty) {
      _allAnimals = response;
      isLoading = false;

      notifyListeners();

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
    await getAllAnimals();

    isLoading = false;

    notifyListeners();
    return response;
  }

  Future deleteAnimal(int animalId) async {
    isLoading = true;
    notifyListeners();
    final response = await _animalServices.deleteAnimal(animalId);
    await getAllAnimals();
    _allAnimals.removeWhere((animal) => animal.animalId == animalId);

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

  Future getTaskTypeById(int taskTypeId) async {
    isLoading = true;
    notifyListeners();

    final response = await _taskTypeServices.getTaskTypeById(taskTypeId);
    if (response != null) {
      isLoading = false;
      setSelectedTaskType({
        "taskTypeId": response.taskTypeId,
        "name": response.name
      });
      notifyListeners();
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

    final response = await _animalTypeServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      _allAnimalTypes = response;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getAnimalTypeById(int animalTypeId) async {
    isLoading = true;

    final response = await _animalTypeServices.getAnimalTypeById(animalTypeId);
    if (response != null) {
      isLoading = false;
      setSelectedAnimalType({
        "animalTypeId": response.animalTypeId,
        "name": response.name
      });
      notifyListeners();

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
    final response = await _foodTypeServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      _allFoodTypes = response;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getFoodTypeById(int foodTypeId) async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeServices.getFoodTypeById(foodTypeId);
    if (response != null) {
      isLoading = false;
      notifyListeners();

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

  //Rapports
  Future getAllRapports() async {
    isLoading = true;
    final response = await _rapportServices.getAll();
    if (response.isNotEmpty) {
      isLoading = false;
      _allRapports = response;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getRapportById(int rapportId) async {
    isLoading = true;

    final response = await _rapportServices.getRapportById(rapportId);
    if (response != null) {
      isLoading = false;
      notifyListeners();

      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getRapportByDate(DateTime date) async{
    isLoading = true;

    final response = await _rapportServices.getRapportByDate(date);
    if(response != null){
      isLoading = false;
      _rapportsForToday = response;
      notifyListeners();
      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createRapport(Rapport rapport) async {
    isLoading = true;

    final response = await _rapportServices.makeRapport(rapport);
    getAllRapports();

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteRapport(int rapportId, [date]) async {
    isLoading = true;
    final response = await _rapportServices.deleteRapport(rapportId);
    if(date != null){
      getRapportByDate(date);
    }
    else{
      getAllRapports();
    }

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editRapport(Rapport rapport, int rapportId) async {
    isLoading = true;
    final response = await _rapportServices.editRapport(rapport, rapportId);
    getAllRapports();

    isLoading = false;
    notifyListeners();
    return response;
  }

  //Many-Many

  //UserTasks
  Future getAllUserTasksByUserId(int userId) async {
    try {
      isLoading = true;
      final response = await _userTaskServices.getByUserId(userId);
      if (response != null) {
        //_allUserTasks = response;
        _allTasks = response["tasks"];
        isLoading = false;
        notifyListeners();
        return response;
      }
    }
      catch(e){
        print(e);
      }
      finally{
        isLoading = false;
        notifyListeners();
      }

    return [];
  }
  Future getUserTasksByUserIdForToday(int userId, String language, [limit]) async {
    try {
      isLoading = true;
      final response = await _userTaskServices.getByUserIdForToday(userId, language, limit);
      if (response != null) {
        // Assuming _allTasks is a list of tasks
        _allTasks = response["tasks"];

        isLoading = false;
        notifyListeners();
        return _allTasks;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return [];
  }

  Future getAllTaskUsersByTaskId(int taskId) async {
    isLoading = true;
    notifyListeners();

    final response = await _userTaskServices.getByTaskId(taskId);
    if (response != null) {

      _allTaskUsers = response["users"];
      isLoading = false;
      notifyListeners();
      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }



  Future createUserTask(UserTask userTask) async {
    isLoading = true;
    notifyListeners();

    final response = await _userTaskServices.makeUserTask(userTask);
    //?TODO Haal hier misschien de andere taken of users op
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteUserTask(int userTaskId) async {
    isLoading = true;
    notifyListeners();
    final response = await _userTaskServices.deleteUserTask(userTaskId);
    //?TODO Haal hier misschien de andere taken of users op

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editUserTask(UserTask userTask, int userTaskId) async {
    isLoading = true;
    notifyListeners();
    final response = await _userTaskServices.editUserTask(userTask, userTaskId);
    //?TODO Haal hier misschien de andere taken of users op

    isLoading = false;
    notifyListeners();
    return response;
  }

  //FoodtypeAnimal

  Future getAllAnimalTypesByFoodTypeId(int foodTypeId) async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeAnimalTypeServices.getAnimalTypesByFoodTypeId(foodTypeId);
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      //_allAnimalTypesFoodType = response;
      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
  Future getAllFoodTypesByAnimalId(int animalId) async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeAnimalTypeServices.getFoodTypeAnimalTypeByAnimalTypeId(animalId);
    if (response.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      return response;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future createFoodTypeAnimalType(FoodtypeAnimal foodTypeAnimal) async {
    isLoading = true;
    notifyListeners();

    final response = await _foodTypeAnimalTypeServices.makeFoodTypeAnimal(foodTypeAnimal);
    //?TODO Haal hier misschien de andere taken of users op
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteFoodTypeAnimalType(int foodTypeAnimalTypeId) async {
    isLoading = true;
    notifyListeners();
    final response = await _foodTypeAnimalTypeServices.deleteFoodTypeAnimal(foodTypeAnimalTypeId);
    //?TODO Haal hier misschien de andere taken of users op

    isLoading = false;
    notifyListeners();
    return response;
  }

  Future editFoodTypeAnimal(FoodtypeAnimal foodTypeAnimal, int foodTypeAnimalId) async {
    isLoading = true;
    notifyListeners();
    final response = await _foodTypeAnimalTypeServices.editFoodTypeAnimal(foodTypeAnimal, foodTypeAnimalId);
    //?TODO Haal hier misschien de andere taken of users op
    isLoading = false;
    notifyListeners();
    return response;
  }

  //!TODO hier nog de messages





  //Widget functions

  Widget buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType inputType = TextInputType.text,
        int maxLines = 1,
        double sizeForFont = 16,
        bool isPassword = false,
        FloatingLabelBehavior labelBehavior = FloatingLabelBehavior.never,
        FocusNode? focusNode,
      }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      obscureText: isPassword ,
      focusNode: focusNode,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(

          fontSize: sizeForFont
        ),

        floatingLabelBehavior: labelBehavior,
        border: InputBorder.none,
      ),
      style: TextStyle(color: Colors.white, fontSize: sizeForFont),
    );
  }

  Future<DateTime?> pickDateTime(BuildContext context, {DateTime? initialDate}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    setSelectedDate(DateTime(date.year, date.month, date.day, time.hour, time.minute));
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<DateTime?> pickDate(BuildContext context, {DateTime? initialDate}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    _selectedDate = date;
    notifyListeners();
    return date;
  }








  showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () => closeSnackBar(context), // Corrected: pass as a callback
      ),
    ));
  }

  closeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  Widget buildOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Setters
  setSelectedPriority(int priorityValue){
    _selectedPriority = priorities.firstWhere((e) => e["value"] == priorityValue);
    notifyListeners();
  }

  setSelectedAnimalType(Map animalType){
    _selectedAnimalType = animalType;
    notifyListeners();
  }

  setUsersLanguage(String usersLanguage){
    _usersLanguage = usersLanguage;
    notifyListeners();
  }

  setSelectedTaskType(Map taskType){
    _selectedTaskType = taskType;
    notifyListeners();
  }

  setSelectedStock(Map stock){
    _selectedStock = stock;
    notifyListeners();
  }
  setSelectedQuantity(int quantity){
    _selectedQuantity = quantity;
    notifyListeners();
  }
  setSelectedDate(DateTime newDate){
    _selectedDate = newDate;
    notifyListeners();
  }

  setSelectedFunction(int function){
    _selectedFunction = function;
    notifyListeners();
  }

  setSelectedFilter(String filter){
    _selectedFilter = filter;
    notifyListeners();
  }
  setSelectedFilterChoice(String filterChoice){
    _selectedFilterChoice = filterChoice;
    notifyListeners();
  }
  setSelectedDaily(bool isSelected){
    _isSelectedDaily = isSelected;
    notifyListeners();
  }
  setSelectedFinished(bool isFinished){
    _isSelectedFinished = isFinished;
    notifyListeners();
  }
  addToSelectedAnimalTypes(Map animalType){
    _selectedAnimalTypes.add(animalType);
    notifyListeners();
  }
  removeFromSelectedAnimalTypes(int animalTypeId){
    _selectedAnimalTypes.removeWhere((animalType) => animalType['animalTypeId'] == animalTypeId);
    notifyListeners();
  }

  addToSelectedFoodTypes(Map foodType){
    _selectedFoodTypes.add(foodType);
    notifyListeners();
  }
  removeFromSelectedFoodTypes(int foodTypeId){
    _selectedFoodTypes.removeWhere((foodType) => foodType['foodTypeId'] == foodTypeId);
    notifyListeners();
  }


  addToSelectedUsers(Map user){
    _selectedUsers.add(user);
    notifyListeners();
  }
  removeFromSelectedUsers(int userId) {
    _selectedUsers.removeWhere((user) => user['userId'] == userId);
    notifyListeners();
  }

  //Cleaners
  cleanSelectedUsers(){
    _selectedUsers.clear();
    _allTaskUsers.clear();
    getAllUsers();
    notifyListeners();
  }
  cleanSelectedAnimals(){
    _selectedAnimalTypes.clear();
    _selectedFoodTypes.clear();
    notifyListeners();
  }
  cleanSelected(){
    _selectedDate = null;
    _selectedQuantity = 0;
    _selectedStock = {};
    _selectedTaskType = {};
    _selectedPriority = {};
    _selectedFunction = null;
    _isSelectedFinished = false;
    _isSelectedDaily = false;
    _selectedAnimalType = {};
    notifyListeners();
  }
}
