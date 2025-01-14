import 'package:bio_art_planner_v2/models/classes/Task.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/classes/Rapport.dart';
import '../../models/classes/User.dart';
import '../../models/globalProvider.dart';

class RapportScreen extends StatefulWidget {
  final Rapport rapport;
  const RapportScreen({
    required this.rapport,
    super.key
  });

  @override
  State<RapportScreen> createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  late User user;
  List<Task> tasksForUserRapport = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future getNeededInfo() async{
    user = await context.read<GlobalProvider>().getUserById(widget.rapport.userId);
    tasksForUserRapport = await context.read<GlobalProvider>().getTasksByRapportId(widget.rapport.rapportId!);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.rapport.title.toString()), backgroundColor: Colors.deepPurple,),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: FutureBuilder(
          future: getNeededInfo(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(
    child: Text('Error: ${snapshot.error}'),
    );
    } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date", style: TextStyle( fontWeight: FontWeight.bold),),
                Text(DateFormat("yyyy-MM-dd").format(widget.rapport.date!)),
                SizedBox(height: 10,),
                Text("Made by", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${user.username}"),
                SizedBox(height: 10,),
                Text("Exceptionalitites", style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.rapport.exceptionalities.toString(), maxLines: 5,),
                SizedBox(height: 10,),
                Text("Tasks:", style: TextStyle(fontWeight: FontWeight.bold),),
                Expanded(
                  child: GroupedListView<dynamic, String>(
                    elements: tasksForUserRapport,
                    groupBy: (task) => task.animalTypeInString ?? "No animal type",
                    groupComparator: (value1, value2) {
                      if (value1 == "No animal type") return -1;
                      if (value2 == "No animal type") return 1;
                      return value2.compareTo(value1); // Descending order for groups
                    },
                    itemComparator: (task1, task2) => task1.title.compareTo(task2.title), // Custom comparator for tasks
                    order: GroupedListOrder.DESC, // Descending order for items
                    groupSeparatorBuilder: (String group) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        group,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    itemBuilder: (context, task) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[350]
                              : Colors.grey[850],
                        ),
                        child: ListTile(
                          title: Text(task.title.toString()),
                          leading: task.finished == 1
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.close_rounded, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),

              ]);
          }},

        ),
      ),
    );
  }
}
