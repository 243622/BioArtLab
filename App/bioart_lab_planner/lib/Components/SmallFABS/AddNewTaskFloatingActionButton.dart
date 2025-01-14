import 'package:bioartlab_planner/models/classes/TaskType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import '../../models/classes/Task.dart';

class AddNewTaskFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;
  const AddNewTaskFloatingActionButton({
    super.key,
    required this.keyFab,
  });

  @override
  State<AddNewTaskFloatingActionButton> createState() => _AddNewTaskFloatingActionButtonState();
}

class _AddNewTaskFloatingActionButtonState extends State<AddNewTaskFloatingActionButton> {
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;
  late TextEditingController taskPriorityController;
  late TextEditingController taskTypeController;
  late TextEditingController taskQuantityController;
  TaskType? dropDownValue;
  DateTime? deadline;
  late GlobalKey<ExpandableFabState> keyToClose;

  @override
  void initState() {
    super.initState();
    taskTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    taskPriorityController = TextEditingController();
    taskTypeController = TextEditingController();
    taskQuantityController = TextEditingController();
    keyToClose = widget.keyFab;

  }


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: null,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 20),
                    _buildTextField(taskTitleController, 'Task Name (required)'),
                    const SizedBox(height: 15),
                    _buildTextField(taskDescriptionController, 'Task Description (required)', maxLines: 3),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            taskPriorityController,
                            'Priority (required)',
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child:DropdownMenu<TaskType>(
                            initialSelection: null,
                            dropdownMenuEntries: context.watch<GlobalProvider>().allTaskTypes.map<DropdownMenuEntry<TaskType>>((TaskType e) {
                              return DropdownMenuEntry<TaskType>(
                                value: e,
                                label: e.name,
                              );
                            }).toList(),
                            hintText: "Select Task Type", // Text to show when nothing is selected
                            onSelected: (TaskType? newValue) {
                              setState(() {
                                dropDownValue = newValue;
                              });
                            },
                          ),

                        )],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(taskQuantityController, 'Quantity', inputType: TextInputType.number),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        deadline = await _pickDateTime(context, initialDate: deadline);
                      },
                      child: Text(deadline == null ? 'Pick Deadline' : 'Change Deadline'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<GlobalProvider>(
                      builder: (context, taskManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if(taskTitleController.text.isNotEmpty && taskDescriptionController.text.isNotEmpty && taskPriorityController.text.isNotEmpty)
                              {
                                final newTask = Task(
                                  title: taskTitleController.text,
                                  description: taskDescriptionController.text,
                                  priority: int.tryParse(taskPriorityController.text),
                                  taskType: dropDownValue?.taskTypeId,
                                  quantity: int.tryParse(taskQuantityController.text),
                                  deadline: deadline,
                                );
                                taskManager.createTask(newTask);
                                Navigator.pop(context);
                                taskTitleController.clear();
                                taskDescriptionController.clear();
                                taskPriorityController.clear();
                                taskQuantityController.clear();

                              }
                              else{
                                      showSnackBar("Fill de required fields");
                            }
                          },
                          child: const Text("Add Task"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ).whenComplete(() => keyToClose.currentState?.toggle());
      },
      child: const Icon(Icons.add),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<DateTime?> _pickDateTime(BuildContext context, {DateTime? initialDate}) async {
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

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

