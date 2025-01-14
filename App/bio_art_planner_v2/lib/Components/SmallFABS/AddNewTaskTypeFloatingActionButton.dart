import '/models/classes/TaskType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';

class AddNewTaskTypeFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;

  const AddNewTaskTypeFloatingActionButton({
    super.key,
    required this.keyFab,
  });

  @override
  State<AddNewTaskTypeFloatingActionButton> createState() =>
      _AddNewTaskTypeFloatingActionButtonState();
}

class _AddNewTaskTypeFloatingActionButtonState
    extends State<AddNewTaskTypeFloatingActionButton> {
  late TextEditingController taskTypeNameController;
  TaskType? dropDownValue;
  late GlobalKey<ExpandableFabState> keyToClose;

  @override
  void initState() {
    super.initState();
    taskTypeNameController = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "TaskTypeFab",
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
                          'Add new task type',
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
                    context.read<GlobalProvider>().buildTextField(
                        taskTypeNameController, 'Tasktype name (required)'),
                    const SizedBox(height: 20),
                    Consumer<GlobalProvider>(
                      builder: (context, taskManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (taskTypeNameController.text.isNotEmpty) {
                              final newTaskType =
                                  TaskType(name: taskTypeNameController.text);
                              taskManager.createTaskType(newTaskType);
                              Navigator.pop(context);
                              taskTypeNameController.clear();
                            } else {
                              taskManager.showSnackBar("Fill de required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add task type"),
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


}
