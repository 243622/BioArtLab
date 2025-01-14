import 'dart:async';

import 'package:bio_art_planner_v2/ExpandableFabs/ExpandableFabCalender.dart';
import 'package:bio_art_planner_v2/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/classes/Task.dart';
import 'Add_NewScreens/EditTask_Screen.dart';

class CalenderAdminView extends StatefulWidget {
  const CalenderAdminView({super.key});

  @override
  State<CalenderAdminView> createState() => _CalenderAdminViewState();
}

class _CalenderAdminViewState extends State<CalenderAdminView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _focusedDay;
  DateTime? _selectedDay;
  int limit = 20;
  bool isLoadingCalender = false;
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;
  late ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    taskTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(onScroll);

    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    super.initState();

  }
  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      refreshIndicatorKey.currentState?.show();

      limit += 20;
      fetchTasks();
    }
  }
  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  Widget _isTaskFinished(Task task) {
    return task.finished == 0
        ? const Icon(Icons.close_rounded, color: Colors.red)
        : const Icon(Icons.check_circle, color: Colors.green);
  }

  Future<void> fetchTasks({int maxRetries = 10, Duration timeout = const Duration(seconds: 10)}) async {
    isLoadingCalender = true;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Attempt to fetch tasks with a timeout
        await Future.any([

          fetchTasksInternal(), // The actual fetch logic
    Future.delayed(timeout, () => throw TimeoutException("Fetch tasks timed out"))
        ]);
        print("Tasks fetched successfully.");
        context.read<GlobalProvider>().getRapportByDate(DateTime.now());
        isLoadingCalender = false;
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

  Future<void> fetchTasksInternal() async {
    if (_selectedDay != null) {
      print("Fetching tasks for selected day: $_selectedDay");
      await context.read<GlobalProvider>().getTasksByDate(_selectedDay!, limit);
    } else if (_focusedDay != null) {
      print("Fetching tasks for focused day: $_focusedDay");
      await context.read<GlobalProvider>().getTasksByDate(_focusedDay!, limit);
    } else {
      print("Fetching all tasks");
      await context.read<GlobalProvider>().getAllTasks(limit);
    }
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.read<GlobalProvider>();
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFabCalender(listType: "tasksByDay", selectedDate: _selectedDay! ?? _focusedDay!,),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: fetchTasks,
        child: FutureBuilder<void>(
          future: fetchTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay!,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        provider.getTasksByDate(selectedDay);
                        provider.getRapportByDate(selectedDay);
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  context.watch<GlobalProvider>().tasksByDay.isNotEmpty
                      ? Expanded(
                    child:
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      child:
                      isLoadingCalender ? Center(child: CircularProgressIndicator(),) :
                      GroupedListView<dynamic, String>(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        elements: context.watch<GlobalProvider>().tasksByDay,
                        groupBy: (task) => task.animalTypeInString ?? "No animal type", // Group by animalTypeInString
                        groupComparator: (value1, value2) {
                          // Put "No animal type" group at the bottom
                          if (value1 == "No animal type") return -1;
                          if (value2 == "No animal type") return 1;
                          return value2.compareTo(value1); // Keep other groups sorted normally
                        },
                        itemComparator: (task1, task2) => task2.taskType.compareTo(task1.taskType),
                        order: GroupedListOrder.DESC,
                        groupSeparatorBuilder: (String group) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            group,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        itemBuilder: (context, task) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Slidable(
                              key: UniqueKey(),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: ()  async{
                                     await provider.deleteTask(task.taskId!, "tasksByDay");
                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    onPressed: (_)  async{
                                      await provider.deleteTask(task.taskId!, "tasksByDay");
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTaskScreen(
                                            task: task,
                                            taskManager: provider,
                                            taskList: "tasksByDay",
                                          ),
                                        ),
                                      ).then((_){
                                        provider.cleanSelectedUsers();
                                        provider.cleanSelected();

                                        // Update the task in the provider (state management)
                                      });
                                    },
                                    backgroundColor: const Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: Theme.of(context).brightness == Brightness.light
                                          ? [
                                        Colors.grey.shade300 , // Light mode gradient start
                                        Colors.grey.shade200 ,  // Light mode gradient end
                                      ]
                                          : [
                                        Colors.grey.shade900 , // Dark mode gradient start
                                        Colors.grey.shade800 , // Dark mode gradient end
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                    child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                                    collapsedBackgroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: _isTaskFinished(task),
                                    subtitle: Text(task.taskTypeString ?? "No Type"),
                                    title: Text(
                                      task.title ?? "No Title",
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white70,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Description: ${task.description ?? 'No description'}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Task Type: ${task.taskTypeString ?? 'No task type'}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Priority: ${task.priority ?? 'N/A'}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Deadline: ${task.deadline != null ? DateFormat('yyyy-MM-dd').format(task.deadline!) : 'No deadline'}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Stock to be used: ${task.stockTypeString}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Quantity of the stock in kg: ${task.quantity ?? 'No quantity'}",
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Users for this task: ${task.users?.map((user) => user.username).join(', ') ?? 'No users assigned'}",
                                            ),
                                            SizedBox(height: 5,),
                                            Text("Animal this task will be done on: ${task.animalTypeInString ?? "No animal connected"}")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  )
                      : Expanded(
                        child: ListView(
                          children:[
                            const Center(child: Text("No tasks available"),),
                        ]),
                      ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
