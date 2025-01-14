import 'package:bio_art_planner_v2/models/classes/Stock.dart';
import 'package:bio_art_planner_v2/models/globalProvider.dart';
import 'package:bio_art_planner_v2/models/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../../models/classes/Task.dart';
import 'package:hold_to_confirm_button/hold_to_confirm_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Future<Map<String, String>> translationsFuture;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    translationsFuture = translateText();
  }


  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final translations = await Future.wait([
        translator.translate("Description", from: "en", to: usersLanguage),
        translator.translate("Title", from: "en", to: usersLanguage),
        translator.translate("Stock and quantity", from: "en", to: usersLanguage),
        translator.translate("Other users that will be doing this task:", from: "en", to: usersLanguage),
        translator.translate("Type", from: "en", to: usersLanguage),
        translator.translate("Hold to finish the task", from: "en", to: usersLanguage),
        translator.translate("See something wrong with one of the animals? If you cant solve it yourself call Problems: 06-10452100", from: "en", to: usersLanguage)
      ]);

      return {
        "description": translations[0].text,
        "title": translations[1].text,
        "stockAndQuantity": translations[2].text,
        "otherUsers": translations[3].text,
        "type": translations[4].text,
        "button": translations[5].text,
        "inkwell": translations[6].text
      };
    } catch (e) {
      return {
        "description": "Translation failed",
        "title": "Translation failed",
        "stockAndQuantity": "Translation failed",
        "otherUsers": "Translation failed",
        "type": "Translation failed",
        "button": "Translation failed",
        "inkwell": "Translation failed"
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title ?? "Task Details"),
        backgroundColor: Colors.white10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, String>>(
          future: translationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Failed to load translations"));
            }

            final translations = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskDetails(translations),
                const SizedBox(height: 25),
                _buildDescription(translations),
                const SizedBox(height: 10),
                _buildStockAndQuantity(translations),
                const SizedBox(height: 10),
                _buildOtherUsers(translations),
                _buildInkwellOption(translations),
                Expanded(child: Container()),
                _buildActionButton(translations),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskDetails(Map<String, String> translations) {
    return Text(
      "${translations['title']}: ${widget.task.title}",
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(Map<String, String> translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations['description'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(widget.task.description ?? "", style: const TextStyle(fontSize: 14, height: 2)),
      ],
    );
  }

  Widget _buildStockAndQuantity(Map<String, String> translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations['stockAndQuantity'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(widget.task.stockTypeString != null && widget.task.quantity != null && widget.task.quantity != 0
            ? "${widget.task.stockTypeString}, ${widget.task.quantity}"
            : "No stock and quantity added"),
      ],
    );
  }

  Widget _buildOtherUsers(Map<String, String> translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations['otherUsers'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(widget.task.users!.map((e) => e.username).join(', ')),
      ],
    );
  }

  Widget _buildInkwellOption(Map<String, String> translations) {
    return context.read<GlobalProvider>().buildOption(
      icon: Icons.warning,
      label: translations["inkwell"] ?? "",
      onTap: () {

      },
    );
  }

  Widget _buildActionButton(Map<String, String> translations) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(25),
        child: HoldToConfirmButton(
          onProgressCompleted: () => _handleTaskCompletion(context),
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

  Future<void> _handleTaskCompletion(BuildContext context) async {
    if (widget.task.finished == 1) {
      context.read<GlobalProvider>().showSnackBar("You already finished this task.", context);
      return;
    }

    try {
      // Show notification before starting task updates

      // Get task and stock data in parallel
      int taskId = widget.task.taskId!;
      Task updatedTask = await context.read<GlobalProvider>().getTaskById(taskId);

      // Mark the task as finished
      updatedTask.finished = 1;
      updatedTask.doneDate = DateTime.now();

      // Update task
      await context.read<GlobalProvider>().editTask(updatedTask, taskId);

      // Update stock if applicable
      if (updatedTask.stockId != null && updatedTask.stockId != 0) {
        Stock stockToUpdate = await context.read<GlobalProvider>().getStockById(updatedTask.stockId!);

        if (updatedTask.quantity != null && stockToUpdate.quantity != null) {
          stockToUpdate.quantity = stockToUpdate.quantity! - updatedTask.quantity!;
          await context.read<GlobalProvider>().editStock(stockToUpdate, updatedTask.stockId!);



        }
      }

      context.read<GlobalProvider>().updateTask(updatedTask, "allTasks");
      Navigator.pop(context);
    } catch (e) {
      context.read<GlobalProvider>().showSnackBar("Error: $e", context);
    }
  }
}
