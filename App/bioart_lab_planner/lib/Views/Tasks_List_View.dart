import 'package:bioartlab_planner/models/classes/Task.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/classes/TaskType.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;
  late TextEditingController taskPriorityController;
  late TextEditingController taskQuantityController;
  late TextEditingController taskTypeName;

  TaskType? dropDownValue;
  String selectedFilter = 'Tasks';

  @override
  void initState() {
    super.initState();
    taskTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    taskPriorityController = TextEditingController();
    taskQuantityController = TextEditingController();
    taskTypeName = TextEditingController();
  }

  Widget _isTaskFinished(Task task) {
    return task.finished == 0
        ? Icon(Icons.close_rounded, color: Colors.red)
        : Icon(Icons.check_circle, color: Colors.green);
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'Tasks', label: Text('Tasks')),
              ButtonSegment(value: 'Tasktypes', label: Text('Tasktypes')),
              ButtonSegment(value: 'Templates', label: Text('Templates')),
            ],
            selected: {selectedFilter},
            onSelectionChanged: (newSelection) {
              setState(() {
                selectedFilter = newSelection.first;
              });
            },
          ),
        ),
        Expanded(
          child: Consumer<GlobalProvider>(
            builder: (context, taskManager, child) {
              List toShow;

              // Apply filter based on selectedFilter value
              if (selectedFilter == 'Tasks') {
                toShow = taskManager.allTasks;
              } else if (selectedFilter == 'Tasktypes') {
                toShow = taskManager.allTaskTypes;
              } else if (selectedFilter == 'Templates') {
                toShow = []; // Add template list logic here if available
              } else {
                toShow = taskManager.allTasks; // Default to all tasks
              }

              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  var item = toShow[index];
                  if (item is Task) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              taskManager.deleteTask(item.taskId!);
                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                taskManager.deleteTask(item.taskId!);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _editTaskDialog(context, taskManager, item);
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          collapsedBackgroundColor: Colors.grey[850],
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: _isTaskFinished(item),
                          subtitle: Text(item.taskTypeString.toString()),
                          title: Text(
                            item.title.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white70,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description: ${item.description ?? 'No description'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "TaskType: ${item.taskTypeString ?? 'No tasktype'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Priority: ${item.priority ?? 'N/A'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Deadline: ${item.deadline != null ? item.deadline.toString() : 'No deadline'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (item is TaskType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () async{
                              final response = await taskManager.deleteTaskType(item.taskTypeId!);
                              if(response != true){
                                showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                return;
                              }

                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) async{
                                final response = await taskManager.deleteTaskType(item.taskTypeId!);
                                if(response != true){
                                  showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                  return;
                                }
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _editTaskTypeDialog(context, taskManager,item );
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Container(
                          color: Colors.grey[850],
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Text(item.taskTypeId.toString()),
                            title: Text(
                              item.name.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(color: Colors.transparent, height: 10),
                itemCount: toShow.length,
              );
            },
          ),
        ),
      ],
    );
  }

  void _editTaskTypeDialog(
      BuildContext context, GlobalProvider taskManager, TaskType taskType) {
    taskTypeName.text = taskType.name!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${taskType.name}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      taskTypeName, 'Edit task type name (required)'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(taskTypeName.text.isNotEmpty){
                  TaskType updatedTask = TaskType(name: taskTypeName.text);
                  taskManager.editTaskType(updatedTask, taskType.taskTypeId!);
                }
                else{
                  showSnackBar("Fill the required fields");
                }
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _editTaskDialog(
      BuildContext context, GlobalProvider taskManager, Task task) {
    taskTitleController.text = task.title!;
    taskDescriptionController.text = task.description!;
    taskPriorityController.text = task.priority?.toString() ?? '';
    taskQuantityController.text = task.quantity?.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${task.title}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      taskTitleController, 'Edit Task Name (required)'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      taskDescriptionController, 'Edit Description (required)'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      taskPriorityController, 'Edit Priority (required)',
                      inputType: TextInputType.number),
                  const SizedBox(height: 10),
                  DropdownMenu<TaskType>(
                    initialSelection: null,
                    dropdownMenuEntries: context
                        .watch<GlobalProvider>()
                        .allTaskTypes
                        .map<DropdownMenuEntry<TaskType>>((TaskType e) {
                      return DropdownMenuEntry<TaskType>(
                        value: e,
                        label: e.name,
                      );
                    }).toList(),
                    hintText: "Select Task Type",
                    onSelected: (TaskType? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(taskQuantityController, 'Edit Quantity',
                      inputType: TextInputType.number),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(taskTitleController.text.isNotEmpty && taskDescriptionController.text.isNotEmpty && taskPriorityController.text.isNotEmpty){
                  Task updatedTask = Task(
                      title: taskTitleController.text,
                      description: taskDescriptionController.text,
                      priority: int.tryParse(taskPriorityController.text),
                      taskType: dropDownValue?.taskTypeId,
                      quantity: int.tryParse(taskQuantityController.text)
                  );

                  taskManager.editTask(updatedTask, task.taskId!);
                }
                else{
                  showSnackBar("Fill the required fields");
                }
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
