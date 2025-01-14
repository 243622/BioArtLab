
import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/Stock.dart';
import 'package:bio_art_planner_v2/models/classes/many_many/User_Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../models/classes/Task.dart';
import '../../../models/globalProvider.dart';

class AddNewTaskScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String taskList;
   const AddNewTaskScreen({
    super.key,
     required this.taskList,
    required this.selectedDate

  });

  @override

  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;
  late TextEditingController taskPriorityController;
  DateTime? deadline;
  int taskQuantity = 1; // Initial quantity value

  @override
  void initState() {
    super.initState();
    taskTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    taskPriorityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<GlobalProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              provider.buildTextField(
                taskTitleController,
                'Task Title (required)',
                sizeForFont: 24,
              ),
              provider.buildTextField(
                taskDescriptionController,
                'Task Description (required)',
              ),
              const SizedBox(height: 10,),
              _buildOption(
                icon: Icons.flag,
                label: context.watch<GlobalProvider>().selectedPriority["label"] ?? "Select priority (required)",
                onTap: () => _showPrioritySelector(context),
              ),
              const SizedBox(height: 10,),

              _buildOption(
                icon: Icons.task,
                label: context.watch<GlobalProvider>().selectedTaskType["name"] ?? "Select Task Type",
                onTap: () => _showTaskTypeSelector(context),
              ),
              const SizedBox(height: 10,),
              _buildOption(
                icon: Icons.calendar_today,
                label: context.watch<GlobalProvider>().selectedDate != null
                    ? DateFormat().format(context.watch<GlobalProvider>().selectedDate!)
                    : "Select a deadline for the task",
                onTap: () async {
                  provider.pickDateTime(context, initialDate: deadline);
                },
              ),
              const SizedBox(height: 10,),
              _buildOption(
                icon: Icons.storage,
                label: context.watch<GlobalProvider>().selectedStock["foodTypeInString"] != null
                    ? "${context.watch<GlobalProvider>().selectedStock["foodTypeInString"]}, quantity: ${context.watch<GlobalProvider>().selectedQuantity.toString()}"
                    : "Select a stock to connect",
                onTap: () => _showStockSelector(context),
              ),
              const SizedBox(height: 10,),
              _buildOption(
                icon: Icons.person,
                label: context.watch<GlobalProvider>().selectedUsers.isNotEmpty
                    ? context.watch<GlobalProvider>().selectedUsers.map((e) => e['username']).join(', ')
                    : "Connect User (Optional)",
                onTap: () => _showUserSelector(context),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  final isSelected = context.read<GlobalProvider>().isSelectedDaily;
                  context.read<GlobalProvider>().setSelectedDaily(!isSelected);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.repeat, ), // Changed icon for repetition
                          const SizedBox(width: 20),
                          Text(
                            "Repeat this task daily?",
                            style: const TextStyle(fontSize: 16, ),
                          ),
                        ],
                      ),
                      Switch(
                        value: context.watch<GlobalProvider>().isSelectedDaily,
                        onChanged: (value) {
                          context.read<GlobalProvider>().setSelectedDaily(value);
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              _buildOption(icon: Icons.catching_pokemon, label: context.watch<GlobalProvider>().selectedAnimalType["name"] ?? "Select animaltype", onTap: () => _showAnimalTypeSelector(context)),

              SizedBox(height: 10,),


              ElevatedButton(
                onPressed: () async {
                  var selectedPriority = provider.selectedPriority;
                  var selectedStock = provider.selectedStock;
                  var selectedQuantity = provider.selectedQuantity;
                  var selectedUsers = provider.selectedUsers;
                  var selectedTaskType = provider.selectedTaskType;
                  var selectedDate = provider.selectedDate;
                  var selectedAnimalType = provider.selectedAnimalType;

                  if (taskTitleController.text.isNotEmpty &&
                      taskDescriptionController.text.isNotEmpty && selectedPriority.isNotEmpty && selectedTaskType.isNotEmpty) {

                    // Create the new task object
                    final newTask = Task(
                        title: taskTitleController.text,
                        description: taskDescriptionController.text,
                        priority: selectedPriority["value"],
                        taskType: selectedTaskType["taskTypeId"],
                        quantity: selectedQuantity,
                        deadline: selectedDate,
                        stockId: selectedStock["stockId"],
                        daily: context.read<GlobalProvider>().isSelectedDaily ? 1 : 0,
                        animalTypeId: selectedAnimalType["animalTypeId"]
                    );

                    // Create the task (async)
                    var createdTask = await provider.createTask(newTask);

                    // Handle task list refresh in parallel (if applicable)
                    List<Future> refreshTasks = [];
                    if (widget.taskList == "allTasks") {
                      refreshTasks.add(provider.getAllTasks(8));
                      refreshTasks.add(provider.getTasksByDaily(8));
                    } else if (widget.taskList == "tasksByDay") {
                      refreshTasks.add(provider.getTasksByDate(widget.selectedDate));
                    }

                    // Handle user-task creation in parallel
                    if (selectedUsers.isNotEmpty) {
                      var task = createdTask;
                      var taskId = task.taskId;
                      List<Future> userTasks = selectedUsers.map((user) {
                        final userId = user["userId"];
                        UserTask userTask = UserTask(userId: userId, taskId: taskId, daily: task.daily == 1 ? 1 : 0);
                        return provider.createUserTask(userTask);
                      }).toList();

                      // Wait for all user-task creation tasks to finish
                      await Future.wait(userTasks);
                    }

                    // Wait for all refresh tasks to complete (if any)
                    await Future.wait(refreshTasks);

                    // Clean up and navigate
                    provider.cleanSelectedUsers();
                    provider.cleanSelected();
                    Navigator.pop(context);
                  } else {
                    provider.showSnackBar("Fill the required fields", context);
                  }
                },
                child: const Text("Add Task"),
              ),

            ],
          ),
        ),
      ),
    );
  }


  void _showTaskTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final taskTypes = context.read<GlobalProvider>().allTaskTypes;
        return ListView.builder(
          itemCount: taskTypes.length,
          itemBuilder: (context, index) {
            final taskType = taskTypes[index];
            return ListTile(
              title: Text(taskType.name),
              onTap: () {
                context.read<GlobalProvider>().setSelectedTaskType({
                  "taskTypeId": taskType.taskTypeId,
                  "name": taskType.name
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }

  void _showAnimalTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final animalTypes = context.read<GlobalProvider>().allAnimalTypes;
        return ListView.builder(
          itemCount: animalTypes.length,
          itemBuilder: (context, index) {
            final animalType = animalTypes[index];
            return ListTile(
              title: Text(animalType.name),
              onTap: () {
                context.read<GlobalProvider>().setSelectedAnimalType({
                  "animalTypeId": animalType.animalTypeId,
                  "name": animalType.name
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }

  void _showPrioritySelector(BuildContext context){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      final priorities = context.read<GlobalProvider>().priorities;
      return ListView.builder(
        itemCount: priorities.length,
        itemBuilder: (context, index) {
          final priority = priorities[index];
          return ListTile(
            title: Text(priority["label"]),
            onTap: () {
              context.read<GlobalProvider>().setSelectedPriority(priority["value"]);
              Navigator.pop(context); // Close the bottom sheet
            },
          );
        },
      );
    });
  }
  void _showStockSelector(BuildContext context){
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ), builder: (BuildContext context){
      final stocks = context.watch<GlobalProvider>().allStocks;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Select Users to perform this task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                  ),
                ),
              ],
            ),
            DropdownMenu<Stock>(
              width: 500,
              initialSelection: null,
              dropdownMenuEntries: stocks.map<DropdownMenuEntry<Stock>>((Stock e) {
                return DropdownMenuEntry<Stock>(
                  value: e,
                  label: e.foodTypeInString!,
                );
              }).toList(),
              hintText: "Select a stock and quantity that will be used in this task",// Text to show when nothing is selected
              onSelected: (Stock? newValue) {
                context.read<GlobalProvider>().setSelectedStock({
                  "stockId": newValue?.stockId,
                  "quantity": newValue?.quantity,
                  "foodTypeId": newValue?.foodTypeId,
                  "minimumQuantity": newValue?.minimumQuantity,
                  "foodTypeInString": newValue?.foodTypeInString
                });
              },
            ),
            SizedBox(height: 30,),
            const Text("Quantity to be used:"),
            SizedBox(height: 10,),
            InputQty.int(
                maxVal: 100,
                initVal: 0,
                steps: 1,
                minVal: 1,
                onQtyChanged: (val){
                  context.read<GlobalProvider>().setSelectedQuantity(val);
                },
                qtyFormProps: const QtyFormProps(enableTyping: true, style: TextStyle(fontSize: 20)),
                decoration: QtyDecorationProps(
                    isBordered: false,
                    fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[250] : Colors.grey[850],
                    qtyStyle: QtyStyle.classic
                )

            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Connect stock"))
          ],
        ),
      );
    });
  }

  void _showUserSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final provider = context.watch<GlobalProvider>();
        final users = provider.allUsers.where((e) => e.function != 1).toList();
        final selectedUsers = provider.selectedUsers; // Assuming this is a list in your provider.

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with a close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select Users to perform this task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isSelected = selectedUsers.any((u) => u['userId'] == user.userId);

                  return ListTile(
                    title: Text(user.username!),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      if (isSelected) {
                        provider.removeFromSelectedUsers(user.userId!); // Remove user
                      } else {
                        provider.addToSelectedUsers({
                          "userId": user.userId,
                          "username": user.username,
                          "password": user.password,
                          "function": user.function,
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    ).whenComplete((){

    });
  }


  Widget _buildOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
