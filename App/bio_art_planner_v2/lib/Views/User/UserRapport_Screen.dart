import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/Rapport.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hold_to_confirm_button/hold_to_confirm_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../../models/classes/Task.dart';
import '../../models/globalProvider.dart';
import 'TaskDetails_Screen.dart';

class UserRapportScreen extends StatefulWidget {
  const UserRapportScreen({super.key});

  @override
  State<UserRapportScreen> createState() => _UserRapportScreenState();
}

class _UserRapportScreenState extends State<UserRapportScreen> {
  late TextEditingController exceptionalititiesDescriptionController;
  late FocusNode exceptionalititesFocus;

  DateTime? deadline;
  int taskQuantity = 1; // Initial quantity value
  late Future<Map<String, String>> translationsFuture;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    exceptionalititiesDescriptionController = TextEditingController();
    exceptionalititesFocus = FocusNode();
    translationsFuture = translateText();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    exceptionalititiesDescriptionController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final translations = await Future.wait([
        translator.translate("Add a Day Rapport", from: "en", to: usersLanguage),
        translator.translate("Username", from: "en", to: usersLanguage),
        translator.translate("Date", from: "en", to: usersLanguage),
        translator.translate("Exceptionalities? Any found eggs or deaths type here.", from: "en", to: usersLanguage),
        translator.translate("Tasks", from: "en", to: usersLanguage),
        translator.translate("Hold to make a daily rapport", from: "en", to: usersLanguage),
        translator.translate("Warning: you can only make one rapport a day.", to: usersLanguage),
      ]);

      return {
        "title": translations[0].text,
        "username": translations[1].text,
        "date": translations[2].text,
        "exceptionalities": translations[3].text,
        "tasks": translations[4].text,
        "button": translations[5].text,
        "warning": translations[6].text
      };
    } catch (e) {
      return {
        "title": "Translation failed",
        "username": "Translation failed",
        "date": "Translation failed",
        "exceptionalitites": "Translation failed",
        "tasks": "Translation failed",
        "button": "Translation failed",
        "warning": "Translation failed,"
      };
    }
  }

  Future didUserMakeRapport() async {
    final rapports = await context.read<GlobalProvider>().getRapportByDate(DateTime.now());

    var userRapport = rapports.where((e) => e.userId == context.read<GlobalProvider>().currentUser["userId"]).toList();

    return userRapport;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: translationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text("Failed to load translations"));
        }
        final translations = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text("${translations["title"] ?? ""}"),
            backgroundColor: Colors.white10,
          ),
          body: GestureDetector(
            onTap: () {
              setState(() {
                FocusManager.instance.primaryFocus?.unfocus();
                exceptionalititesFocus.unfocus();
              });
            },
            child: ListView( // Use ListView for scrollable content
              padding: const EdgeInsets.all(10.0),
              children: [
                _buildUserDetails(translations),
                _buildDescriptionField(translations),
                _buildTaskOption(translations),
                _buildFooterButton(translations),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.red, size: 20), // Info icon
                const SizedBox(width: 8), // Space between icon and text
                Expanded(
                  child: Text(
                    "${translations["warning"]}" ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              ],
            )],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserDetails(Map<String, String> translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextWithTitle("${translations["username"] ?? ""}: ", context.read<GlobalProvider>().currentUser["username"]),
        _buildTextWithTitle("${translations["date"] ?? ""}: ", DateFormat().format(DateTime.now())),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextWithTitle(String title, String content) {
    return Text.rich(
      TextSpan(
        text: title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: content,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(Map<String, String> translations) {
    return context.read<GlobalProvider>().buildTextField(
      exceptionalititiesDescriptionController,
      translations["exceptionalities"] ?? "",
      maxLines: 5,
      focusNode: exceptionalititesFocus,
    );
  }

  Widget _buildTaskOption(Map<String, String> translations) {
    return context.read<GlobalProvider>().buildOption(
      icon: Icons.file_copy,
      label: translations["tasks"] ?? "",
      onTap: () => _showTaskModal(context),
    );
  }

  void _showTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[200]
          : Colors.grey[900],
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<GlobalProvider>(
          builder: (context, taskManager, child) {
            final tasks = taskManager.allTasks;
            if (tasks.isEmpty) {
              return const Center(child: Text("No tasks available.", style: TextStyle(color: Colors.grey)));
            }
            return GroupedListView<dynamic, String>(
              shrinkWrap: true,
              elements: tasks,
              groupBy: (task) => task.animalTypeInString ?? "No animal type",
              groupComparator: (value1, value2) => value1.compareTo(value2),
              itemComparator: (task1, task2) => task1.taskType.compareTo(task2.taskType),
              order: GroupedListOrder.ASC,
              groupSeparatorBuilder: (String group) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(group, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
              ),
              itemBuilder: (context, task) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsScreen(task: task),
                    ),
                  );
                },
                child: _buildTaskCard(task),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            task.finished == 1 ? Colors.green.shade600 : Colors.redAccent.shade400,
            task.finished == 1 ? Colors.green.shade400 : Colors.redAccent.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          task.finished == 1
              ? const Icon(Icons.check_circle, color: Colors.white)
              : const Icon(Icons.pending, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(Map<String, String> translations) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(25),
        child: HoldToConfirmButton(
          onProgressCompleted: () => _handleRapportSubmission(context),
          hapticFeedback: false,
          child: Center(
            child: Text(
              translations["button"] ?? "",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Future<void> _handleRapportSubmission(BuildContext context) async {
    try {
      // Check if the user has already made a rapport today
      var result = await didUserMakeRapport();
      if (result.isNotEmpty) {
        context.read<GlobalProvider>().showSnackBar("You already made a rapport for today", context);
        return;
      }

      // Fetch user data and tasks concurrently
      final userDataFuture = context.read<GlobalProvider>().currentUser;
      final tasksFuture = context.read<GlobalProvider>().allTasks;

      // Wait for both to complete
      final userData = await userDataFuture;
      final tasks = await tasksFuture;

      // Prepare rapport data
      final rapport = Rapport(
        title: "${userData["username"]} : ${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
        exceptionalities: exceptionalititiesDescriptionController.text.isNotEmpty
            ? exceptionalititiesDescriptionController.text
            : "None",
        userId: userData["userId"],
      );

      // Create rapport and decode it
      final createdRapport = await context.read<GlobalProvider>().createRapport(rapport);
      final rapportToDecode = jsonDecode(createdRapport);

      // Collect tasks that need to be updated
      final tasksToUpdate = tasks.where((task) => task.rapportId == null || task.rapportId == 0).toList();

      // Update tasks in parallel
      final updateTasksFutures = tasksToUpdate.map((task) async {
        task.rapportId = rapportToDecode["rapportId"];
        await context.read<GlobalProvider>().editTask(task, task.taskId!);
      }).toList();

      // Wait for all task updates to complete
      await Future.wait(updateTasksFutures);

      // Successfully completed, go back
      Navigator.pop(context);
      context.read<GlobalProvider>().showSnackBar("Succesfully made a rapport", context);
    } catch (e) {
      context.read<GlobalProvider>().showSnackBar("Something went wrong, try again", context);
      print(e);
    }
  }




}
