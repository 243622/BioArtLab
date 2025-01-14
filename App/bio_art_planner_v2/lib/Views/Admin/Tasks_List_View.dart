import 'dart:async';

import 'package:bio_art_planner_v2/Views/Admin/Add_NewScreens/EditTask_Screen.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../models/classes/Task.dart';
import '../../models/classes/User.dart';
import '../../models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/classes/TaskType.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;
  late TextEditingController taskTypeName;
  late ScrollController scrollController;
  DateTime? deadline;
  TaskType? dropDownValue;
  late Future<void> tasksFuture;
  int limit = 8;
  int offset = 0;


  @override
  void initState() {
    super.initState();
    taskTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    taskTypeName = TextEditingController();
    scrollController = ScrollController();
    tasksFuture = getTasksBySelected();

    scrollController.addListener(onScroll);
    Future.microtask(() {
      context.read<GlobalProvider>().setSelectedFilter("Tasks");
      context.read<GlobalProvider>().setSelectedFilterChoice("Alle tasks");
    });
    }
  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    scrollController.dispose();
    super.dispose();
  }
  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      refreshIndicatorKey.currentState?.show();

      limit += 6;
      getTasksBySelected();
    }
  }



  Widget _isTaskFinished(Task task) {
    return task.finished == 0
        ? const Icon(Icons.close_rounded, color: Colors.red)
        : const Icon(Icons.check_circle, color: Colors.green);
  }
  Future<void> getTasksBySelected({int maxRetries = 10, Duration timeout = const Duration(seconds: 10)}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Attempt to fetch tasks with a timeout
        await Future.any([
          getTasksBySelectedInternal(), // The actual fetch logic
          Future.delayed(timeout, () => throw TimeoutException("Fetch tasks timed out"))
        ]);
        print("Tasks fetched successfully.");
        return; // Exit the loop on success
      } catch (e) {
        retryCount++;
        print("Fetch attempt $retryCount failed: $e");
        if (retryCount >= maxRetries) {
          rethrow; // Re-throw the error if max retries reached
        }
      }
    }

  }

  Future<void> getTasksBySelectedInternal() async {
    final provider = context.read<GlobalProvider>();
    final selectedFilter = provider.selectedFilter;
    final selectedFilterChoice = provider.selectedFilterChoice;

    try {
      if (selectedFilter == "Tasks") {
        switch (selectedFilterChoice) {
          case "Alle tasks":
            await provider.getAllTasks(limit, offset);

            break;

          case "Filter by finished":
            await provider.getAllTasks(limit,offset, 1);

            break;

          case "Filter by priority":
            await provider.getAllTasks(limit,offset, null, null, 1);

            break;

          case "Filter by user":
            await _showUserFilterDialog(provider);

            break;

          default:
            await provider.getAllTasks(limit, offset);
            break;
        }
      } else if (selectedFilter == "Tasktypes") {
        await provider.getAllTaskTypes();
      } else if (selectedFilter == "Daily") {
        await provider.getTasksByDaily(limit);
      } else {
        await provider.getAllTasks(limit, offset);
      }
    } catch (e) {
      // Handle potential errors, e.g., show a toast or log them.
      debugPrint("Error while fetching tasks: $e");
    }
  }

// Extract dialog logic for filtering by user.
  Future<void> _showUserFilterDialog(GlobalProvider provider) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Which user's tasks do you want to see?"),
          content: DropdownMenu<User>(
            width: 500,
            initialSelection: null,
            dropdownMenuEntries: provider.allUsers.map<DropdownMenuEntry<User>>((User e) {
              return DropdownMenuEntry<User>(
                value: e,
                label: e.username!,
              );
            }).toList(),
            hintText: "Select a user to filter by",
            onSelected: (User? newValue) async{
              if (newValue != null) {
                await provider.getAllUserTasksByUserId(newValue.userId!);
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var selectedFilterChoiceForRefresh = context.watch<GlobalProvider>().selectedFilterChoice;

    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: getTasksBySelected,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSegmentedButton(),
                if (context.watch<GlobalProvider>().selectedFilter == "Tasks")
                  _buildPopupMenu(selectedFilterChoiceForRefresh),
              ],
            ),
          ),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildSegmentedButton() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Tasks', label: Text('Tasks')),
        ButtonSegment(value: 'Tasktypes', label: Text('Tasktypes')),
        ButtonSegment(value: 'Daily', label: Text('Daily')),
      ],
      selected: {context.watch<GlobalProvider>().selectedFilter.toString()},
      onSelectionChanged: (newSelection) async {
        limit = 8;
        await context.read<GlobalProvider>().setSelectedFilter(newSelection.first);
        await getTasksBySelected();
      },
    );
  }

  Widget _buildPopupMenu(String selectedFilterChoiceForRefresh) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings),
      onSelected: (selected) {
        context.read<GlobalProvider>().setSelectedFilterChoice(selected);
        getTasksBySelectedInternal();
      },
      itemBuilder: (BuildContext context) {
        final filterChoices = context.read<GlobalProvider>().filterChoices;
        return filterChoices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(choice),
                if (choice == selectedFilterChoiceForRefresh)
                  const Icon(Icons.check, color: Colors.green),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildTaskList() {
    return FutureBuilder(
      future: tasksFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return context.watch<GlobalProvider>().isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<GlobalProvider>(
            builder: (context, taskManager, child) {
              List toShow = _getTasksToShow(taskManager);
              if (toShow.isEmpty) {
                return const Center(child: Text("No tasks"));
              }
              return _buildTaskListView(taskManager, toShow);
            },
          );
        }
      },
    );
  }

  List _getTasksToShow(GlobalProvider taskManager) {
    switch (taskManager.selectedFilter) {
      case 'Tasktypes':
        return taskManager.allTaskTypes;
      case 'Daily':
        return taskManager.tasksByDaily;
      default:
        return taskManager.allTasks;
    }
  }

  Widget _buildTaskListView(GlobalProvider taskManager, List toShow) {
    return taskManager.selectedFilter == "Daily"
        ? _buildGroupedListView(taskManager)
        : _buildRegularListView(toShow, taskManager);
  }

  Widget _buildGroupedListView(GlobalProvider taskManager) {
    return GroupedListView<dynamic, String>(
      controller: scrollController,
      shrinkWrap: true,
      elements: taskManager.tasksByDaily,
      groupBy: (task) => task.animalTypeInString ?? "No animal type",
      groupComparator: (value1, value2) {
        if (value1 == "No animal type") return -1;
        if (value2 == "No animal type") return 1;
        return value2.compareTo(value1);
      },
      itemComparator: (task1, task2) => task2.taskType.compareTo(task1.taskType),
      order: GroupedListOrder.DESC,
      groupSeparatorBuilder: (String group) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(group, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
      ),
      itemBuilder: (context, task) => _buildTaskItem(task, taskManager, "tasksByDaily"),
    );
  }

  Widget _buildRegularListView(List toShow, GlobalProvider taskManager) {
    return ListView.separated(
      controller: scrollController,
      itemCount: toShow.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent, height: 10),
      itemBuilder: (context, index) {
        var item = toShow[index];
        if (item is Task) {
          return _buildTaskItem(item, taskManager, "allTasks");
        } else if (item is TaskType) {
          return _buildTaskTypeItem(item, taskManager);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildTaskItem(Task task, GlobalProvider taskManager, String listType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () => taskManager.deleteTask(task.taskId!, listType)),
          children: [
            _buildDeleteAction(task, taskManager, listType),
            _buildEditAction(task, taskManager, listType),
          ],
        ),
        child: _buildTaskExpansionTile(task),
      ),
    );
  }

  Widget _buildDeleteAction(Task task, GlobalProvider taskManager, String listType) {
    return SlidableAction(
      onPressed: (_) => taskManager.deleteTask(task.taskId!, listType),
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Delete',
    );
  }

  Widget _buildEditAction(Task task, GlobalProvider taskManager, String listType) {
    return SlidableAction(
      onPressed: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: task, taskManager: taskManager, taskList: listType),
          ),
        ).then((_) {
          taskManager.cleanSelectedUsers();
          taskManager.cleanSelected();
        });
      },
      backgroundColor: const Color(0xFF21B7CA),
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
    );
  }

  Widget _buildTaskExpansionTile(Task task) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.light
                ? [Colors.grey.shade300, Colors.grey.shade200]
                : [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: _isTaskFinished(task),
          subtitle: Text(task.taskTypeString ?? "No Type"),
          title: Text(task.title ?? "No Title"),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
          children: _buildTaskDetails(task),
        ),
      ),
    );
  }

  List<Widget> _buildTaskDetails(Task task) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${task.description ?? 'No description'}"),
            const SizedBox(height: 5),
            Text("Task Type: ${task.taskTypeString ?? 'No task type'}"),
            const SizedBox(height: 5),
            Text("Priority: ${task.priority ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text("Deadline: ${task.deadline != null ? DateFormat('yyyy-MM-dd').format(task.deadline!) : 'No deadline'}"),
            const SizedBox(height: 5),
            Text("Stock to be used: ${task.stockTypeString}"),
            const SizedBox(height: 5),
            Text("Quantity of the stock in kg: ${task.quantity ?? 'No quantity'}"),
            const SizedBox(height: 5),
            Text("Users for this task: ${task.users?.map((user) => user.username).join(', ') ?? 'No users assigned'}"),
            const SizedBox(height: 5),
            Text("Animal this task will be done on: ${task.animalTypeInString ?? "No animal connected"}")
          ],
        ),
      ),
    ];
  }

  Widget _buildTaskTypeItem(TaskType item, GlobalProvider taskManager) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () async {
              final response = await taskManager.deleteTaskType(item.taskTypeId!);
              if (response != true) {
                taskManager.showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks", context);
                return;
              }
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) async {
                final response = await taskManager.deleteTaskType(item.taskTypeId!);
                if (response != true) {
                  taskManager.showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks", context);
                  return;
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (context) {
                _editTaskTypeDialog(taskManager, item);
              },
              backgroundColor: const Color(0xFF21B7CA),
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: Container(
          color: Theme.of(context).brightness == Brightness.light ? Colors.grey[350] : Colors.grey[850],
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Text(item.taskTypeId.toString()),
            title: Text(item.name.toString()),
          ),
        ),
      ),
    );
  }

  void _editTaskTypeDialog(GlobalProvider taskManager, TaskType taskType) {
    taskTypeName.text = taskType.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${taskType.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  taskManager.buildTextField(taskTypeName, 'Edit task type name (required)'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (taskTypeName.text.isNotEmpty) {
                  TaskType updatedTask = TaskType(name: taskTypeName.text);
                  taskManager.editTaskType(updatedTask, taskType.taskTypeId!);
                } else {
                  taskManager.showSnackBar("Fill the required fields", context);
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

}
