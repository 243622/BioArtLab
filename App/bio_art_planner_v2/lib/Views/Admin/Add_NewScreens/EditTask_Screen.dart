import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/classes/Stock.dart';
import '../../../models/classes/Task.dart';
import '../../../models/classes/User.dart';
import '../../../models/classes/many_many/User_Task.dart';
import '../../../models/globalProvider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final GlobalProvider taskManager;
  final String taskList;
  const EditTaskScreen({
    super.key,
    required this.task,
    required this.taskManager,
    required this.taskList
});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskTitleController.text = widget.task.title!;
    taskDescriptionController.text = widget.task.description!;
    Future.microtask(() {
      final provider = context.read<GlobalProvider>();
      if (widget.task.deadline != null) provider.setSelectedDate(widget.task.deadline!);
      if (widget.task.taskType != null) provider.getTaskTypeById(widget.task.taskType!);
      if (widget.task.stockId != null) provider.getStockById(widget.task.stockId!);
      if (widget.task.quantity != null) provider.setSelectedQuantity(widget.task.quantity!);
      if (widget.task.priority != 0 && widget.task.priority != null) provider.setSelectedPriority(widget.task.priority!);
      if(widget.task.finished != 0) provider.setSelectedFinished(true);
      if(widget.task.daily != 0) provider.setSelectedDaily(true);
      if(widget.task.animalTypeId != null) provider.getAnimalTypeById(widget.task.animalTypeId!);

    });

  }

  @override
  Widget build(BuildContext context) {
    final taskManager = widget.taskManager;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.task.title}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              taskManager.buildTextField(taskTitleController, 'Edit Task Name (required)', sizeForFont: 24),
              const SizedBox(height: 10),
              taskManager.buildTextField(taskDescriptionController, 'Edit Description (required)'),
              const SizedBox(height: 20),
              taskManager.buildOption(
                icon: Icons.flag,
                label: context.watch<GlobalProvider>().selectedPriority["label"] ?? "Select priority (required)",
                onTap: () => _showPrioritySelector(context),
              ),
              const SizedBox(height: 10),
              taskManager.buildOption(
                icon: Icons.task,
                label: context.watch<GlobalProvider>().selectedTaskType["name"] ?? "Select Task Type",
                onTap: () => _showTaskTypeSelector(context),
              ),
              const SizedBox(height: 10),
              taskManager.buildOption(
                icon: Icons.calendar_today,
                label: context.watch<GlobalProvider>().selectedDate != null
                    ? DateFormat().format(context.watch<GlobalProvider>().selectedDate!)
                    : "Select a deadline for the task",
                onTap: () async {
                  context.read<GlobalProvider>().pickDateTime(context, initialDate: widget.task.deadline);
                },
              ),
              const SizedBox(height: 10),
              taskManager.buildOption(
                icon: Icons.storage,
                label: context.watch<GlobalProvider>().selectedStock["foodTypeInString"] != null
                    ? "${context.watch<GlobalProvider>().selectedStock["foodTypeInString"]}, "
                    "quantity: ${context.watch<GlobalProvider>().selectedQuantity.toString()} kg"
                    : "Select a stock to connect",
                onTap: () => _showStockSelector(context),
              ),
              const SizedBox(height: 10),
              taskManager.buildOption(
                icon: Icons.person,
                label: (widget.task.users != null && widget.task.users!.isNotEmpty)
                    ? widget.task.users!.map((e) => e.username).join(', ')
                    : "Connect User (Optional)",
                onTap: () => _showUserSelector(context, widget.task),
              ),
              const SizedBox(height: 10),
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
                        inactiveTrackColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[250] : Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  final isSelected = context.read<GlobalProvider>().isSelectedFinished;
                  context.read<GlobalProvider>().setSelectedFinished(!isSelected);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.done, ), // Changed icon for repetition
                          const SizedBox(width: 20),
                          Text(
                            "Is this task finished?",
                            style: const TextStyle(fontSize: 16, ),
                          ),
                        ],
                      ),
                      Switch(
                        value: context.watch<GlobalProvider>().isSelectedFinished,
                        onChanged: (value) {
                          context.read<GlobalProvider>().setSelectedFinished(value);
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[250] : Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              taskManager.buildOption(icon: Icons.catching_pokemon, label: context.watch<GlobalProvider>().selectedAnimalType["name"] ?? "Select animaltype", onTap: () => _showAnimalTypeSelector(context)),

              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  if (taskTitleController.text.isNotEmpty &&
                      taskDescriptionController.text.isNotEmpty && taskManager.selectedPriority.isNotEmpty && taskManager.selectedTaskType.isNotEmpty) {
                    final updatedTask = Task(
                      title: taskTitleController.text,
                      description: taskDescriptionController.text,
                      priority: taskManager.selectedPriority["value"],
                      taskType: taskManager.selectedTaskType["taskTypeId"],
                      quantity: taskManager.selectedQuantity,
                      deadline: taskManager.selectedDate,
                      stockId: taskManager.selectedStock["stockId"],
                      daily: taskManager.isSelectedDaily ? 1 : 0,
                      finished: taskManager.isSelectedFinished ? 1 : 0,
                      animalTypeId: taskManager.selectedAnimalType["animalTypeId"]
                    );
                    var usersFirst = await context.read<GlobalProvider>()
                        .getAllTaskUsersByTaskId(widget.task.taskId!);

                    List usersToRemove = usersFirst["users"].where((initialUser) {
                      return !taskManager.selectedUsers.any((selectedUser) =>
                      selectedUser["userId"] == initialUser.userId);
                    }).toList();


                    for (var user in usersToRemove) {
                      for (var userr in usersFirst["users"]) {
                        if (user.userId == userr.userId) {
                          var responseToDecode = jsonDecode(
                              usersFirst["response"]);
                          for (var userTaskToRemove in responseToDecode) {
                            await context.read<GlobalProvider>().deleteUserTask(
                                userTaskToRemove["userTasksId"]);
                          }
                        }
                      }
                    }
                    for (var user in taskManager.selectedUsers) {
                      UserTask userTask = UserTask(
                          userId: user["userId"], taskId: widget.task.taskId!);
                      await context.read<GlobalProvider>().createUserTask(
                          userTask);
                    }
                    // Update task logic
                    var taskForUi = await taskManager.editTask(updatedTask, widget.task.taskId!);
                    taskManager.updateTask(taskForUi, widget.taskList);

                    taskManager.cleanSelectedUsers();

                    Navigator.pop(context);
                  } else {
                    taskManager.showSnackBar("Fill the required fields", context);
                  }
                },
              child: Text("Edit task"))
            ],
          ),
        ),
      ),
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

  void _showUserSelector(BuildContext context, Task task) {
    final provider = context.read<GlobalProvider>();

    provider.cleanSelectedUsers();
    for (var user in task.users!) {
      provider.addToSelectedUsers({
        "userId": user.userId,
        "username": user.username,
        "password": user.password,
        "function": user.function,
      });
    }


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final provider = context.watch<GlobalProvider>();
        final users = provider.allUsers.where((e) => e.function != 1).toList();

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isSelected = provider.selectedUsers
                      .any((u) => u['userId'] == user.userId);

                  return ListTile(
                    title: Text(user.username!),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () async {
                      if (isSelected) {

                        provider.removeFromSelectedUsers(user.userId!);
                        task.users = provider.selectedUsers.map((u) {
                          return User(
                            userId: u['userId'],
                            username: u['username'],
                            password: u['password'],
                            function: u['function'],
                          );
                        }).toList();
                      } else {
                        provider.addToSelectedUsers({
                          "userId": user.userId,
                          "username": user.username,
                          "password": user.password,
                          "function": user.function,
                        });

                        task.users = provider.selectedUsers.map((u) {
                          return User(
                            userId: u['userId'],
                            username: u['username'],
                            password: u['password'],
                            function: u['function'],
                          );
                        }).toList();

                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() async{

    });
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
}
