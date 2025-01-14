import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../models/classes/Task.dart';
import '../../models/globalProvider.dart';
import 'TaskDetails_Screen.dart';

class DashBoardUser extends StatefulWidget {
  const DashBoardUser({super.key});

  @override
  State<DashBoardUser> createState() => _DashBoardUserState();
}

class _DashBoardUserState extends State<DashBoardUser> {
  final translator = GoogleTranslator();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  late Future<void> tasksFuture; // Store the Future to avoid multiple calls
  Map<String, String> translations = {}; // Default translations map
  bool isTranslating = false;
  int limit = 40;
  late ScrollController scrollController;
   int firstUndoneIndex = -1;
   String currentLanguage = "";


  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener(onScroll);
    tasksFuture = getTasksForUser().then((_) {
      if (firstUndoneIndex != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            firstUndoneIndex * 140.0, // Adjust estimated item height if needed
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
    // Future.microtask(() {
    //
    // });
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      refreshIndicatorKey.currentState?.show();

      limit += 10;
      getTasksForUser();
    }
  }

  Future<void> getTasksForUser(
      {int maxRetries = 5, Duration timeout = const Duration(
          seconds: 30)}) async {
    int retryCount = 0;
    if(context.read<GlobalProvider>().usersLanguage != "en" && currentLanguage != context.read<GlobalProvider>().usersLanguage){
      translations = await translateText();
      currentLanguage = context.read<GlobalProvider>().usersLanguage;
    }
    while (retryCount < maxRetries) {
      try {
    await Future.any([
          getTasksForUserInternal(),
          Future.delayed(
              timeout, () => throw TimeoutException("Fetch tasks timed out")),
        ]);
    setState(() {

    });
        return; // Exit on success
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow; // Re-throw the error if max retries reached
        }
      }
    }
  }

  Future<void> getTasksForUserInternal() async {
    await context.read<GlobalProvider>().getUserTasksByUserIdForToday(
        context
            .read<GlobalProvider>()
            .currentUser["userId"], context
        .read<GlobalProvider>()
        .usersLanguage,
        limit
    );
      firstUndoneIndex = await context
          .read<GlobalProvider>()
          .allTasks
          .indexWhere((task) => task.finished == 0);
  }


  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      setState(() {
        isTranslating = true;
      });
      final translations = await Future.wait([
        translator.translate("General info", from: "en", to: usersLanguage),
        translator.translate("Time: Animal care must be finished before 12.00.", from: "en", to: usersLanguage),
        translator.translate("Communication: via WhatsApp animalcare group.", from: "en", to: usersLanguage),
        translator.translate("Wheelbarrows and Tools: All wheelbarrows and tools used for animal care must be cleaned immediately after use and stored in their proper place.", from: "en", to: usersLanguage),
        translator.translate("Cleaning supplies: Ensure no cleaning supplies are left lying around.", from: "en", to: usersLanguage),
        translator.translate("Feed bins: Feed bins must be properly sealed after use and refilled on time to avoid running low on food.", from: "en", to: usersLanguage),
        translator.translate("Locks: Pick up the keys for the enclosures at 9:00 at building M from Wing, Sjors or Roy and bring these keys back directly when finished.", from: "en", to: usersLanguage),
        translator.translate("Safety animals: All enclosures must be locked immediately after animal care for the safety of the animals.", from: "en", to: usersLanguage),
        translator.translate("Garbage: Clean all garbage including stuff that is broken or can no longer be used safely. All cardboard boxes on compost. All other materials in trash."),
        translator.translate("Problems: If any problems arrise, sick animal, problem you cant solve yourself call 06-10452100"),
        translator.translate("Other tasks", from: "en", to: usersLanguage),
        translator.translate("Type", from: "en", to: usersLanguage),
        translator.translate("Deadline", from: "en", to: usersLanguage),
      ]);
      setState(() {
        isTranslating = false;
      });
      return {
        "general": translations[0].text,
        "time": translations[1].text,
        "communication": translations[2].text,
        "wheelbarrowsAndTools": translations[3].text,
        "cleaningSupplies": translations[4].text,
        "feedBins": translations[5].text,
        "locks": translations[6].text,
        "safetyAnimals": translations[7].text,
        "garbage": translations[8].text,
        "problems": translations[9].text,
        "otherTasks": translations[10].text,
        "type": translations[11].text,
        "deadline": translations[12].text,
      };
    } catch (e) {
      return {
        "general": "Translation failed",
        "time": "Translation failed",
        "communication": "Translation failed",
        "wheelbarrowsAndTools": "Translation failed",
        "cleaningSupplies": "Translation failed",
        "feedBins": "Translation failed",
        "locks": "Translation failed",
        "safetyAnimals": "Translation failed",
        "otherTasks": "Translation failed",
        "type": "Translation failed",
        "deadline": "Translation failed",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        await getTasksForUser();
      },
      child: FutureBuilder(
        future: tasksFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || isTranslating) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  // Info Button
                  GestureDetector(
                    onTap: () => _showGeneralInfoBottomSheet(context),
                    child: _buildInfoButton(context),
                  ),

                  SizedBox(height: 25),

                  Consumer<GlobalProvider>(
                    builder: (context, taskManager, child) {
                      final tasks = taskManager.allTasks;

                      if (tasks.isEmpty) {
                        return const Center(child: Text("No tasks available."));
                      }

                      return Column(
                        children: [
                          _createGroupedListView(tasks),

                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

// Build Info Button
  Widget _buildInfoButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translations["general"] ?? "General info",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
          ),
          SizedBox(width: 8),
          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.surface,),
        ],
      ),
    );
  }

// Show Bottom Sheet for General Info
  void _showGeneralInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  translations["general"] ?? "General Info",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(thickness: 1, color: Colors.grey),

              // Info List
              ..._buildInfoList(),
            ],
          ),
        );
      },
    );
  }

// Helper function to build the info list
  List<Widget> _buildInfoList() {
    return [
      _buildInfoListTile(
        icon: Icons.access_time,
        title: translations["time"] ?? "Time: Animal care must be finished before 12.00.",
      ),
      _buildInfoListTile(
        icon: Icons.group,
        title: translations["communication"] ?? "Communication: via WhatsApp animalcare group.",
      ),
      _buildInfoListTile(
        icon: FontAwesomeIcons.hammer,
        title: translations["wheelbarrowsAndTools"] ??
            "Wheelbarrows and Tools: All wheelbarrows and tools used for animal care must be cleaned immediately after use and stored in their proper place.",
      ),
      _buildInfoListTile(
        icon: FontAwesomeIcons.carrot,
        title: translations["feedBins"] ??
            "Feed bins: Feed bins must be properly sealed after use and refilled on time to avoid running low on food.",
      ),
      _buildInfoListTile(
        icon: Icons.lock,
        title: translations["locks"] ??
            "Locks: Pick up the keys for the enclosures at 9:00 at building M from Wing, Sjors, or Roy, and bring these keys back directly when finished.",
      ),
      _buildInfoListTile(
        icon: Icons.security,
        title: translations["safetyAnimals"] ??
            "Safety animals: All enclosures must be locked immediately after animal care for the safety of the animals.",
      ),
      _buildInfoListTile(
        icon: FontAwesomeIcons.trash,
        title: translations["garbage"] ??
            "Garbage: Clean all garbage, including stuff that is broken or can no longer be used safely. All cardboard boxes go to compost. All other materials go to trash.",
      ),
      _buildInfoListTile(
        icon: Icons.phone,
        title: translations["problems"] ??
            "Problems: If any problems arise, such as a sick animal or an issue you can't solve yourself, call 06-10452100.",
      ),
    ];
  }

// Reusable Info List Tile Widget
  Widget _buildInfoListTile({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }


  _createGroupedListView(List<Task> tasks) {

    return GroupedListView<dynamic, String>(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      elements: context.watch<GlobalProvider>().allTasks,
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
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      itemBuilder: (context, task) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            ).whenComplete((){

            });
            },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reduced margin for compact spacing
            padding: const EdgeInsets.all(12), // Reduced padding for smaller content
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  task.finished == 1 ? Colors.green.shade600 : Colors.grey.shade500,
                  task.finished == 1 ? Colors.green.shade400 : Colors.grey.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12), // Slightly smaller border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Lighter shadow for subtle depth
                  offset: const Offset(0, 4), // Reduced shadow offset
                  blurRadius: 8, // Reduced blur radius
                ),
              ],
            ),
            child: Row(
              children: [
                // Text content on the left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task title
                      Text(
                        task.title.toString(),
                        style: TextStyle(
                          fontSize: 16, // Smaller font size for the title
                          fontWeight: FontWeight.w500, // Lighter font weight
                          color: Colors.white,
                        ),
                        maxLines: 2, // Ensure title doesn't overflow
                        overflow: TextOverflow.ellipsis, // Add ellipsis if title is too long
                      ),
                      const SizedBox(height: 6), // Smaller space between lines
                      // Task type
                      Text(
                        "${translations["type"] ?? "Type"}: ${task.taskTypeString}",
                        style: const TextStyle(
                          fontSize: 14, // Adjusted font size for type
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced space between lines
                      // Task deadline
                      Text(
                        "${translations["deadline"] ?? "Deadline"}: ${task.deadline != null ? DateFormat().format(task.deadline!) : 'No deadline'}",
                        style: const TextStyle(
                          fontSize: 14, // Adjusted font size for deadline
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon or indicator on the right
              ],
            ),
          )

        );
      },
    );
  }
}

// return ListView.builder(
//   itemCount: tasks.length,
//   itemBuilder: (BuildContext context, int index) {
//     final task = tasks[index];
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TaskDetailsScreen(task: task),
//           ),
//         );
//       },
//       child: TimeLineTileTasks(
//         isFirst: index == 0,
//         isLast: index == tasks.length - 1,
//         isPast: task.finished == 1,
//         task: task,
//       ),
//     );
//   },
// );