import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

import '../../Views/Admin/Add_NewScreens/AddNewTask_Screen.dart';
import '../../models/globalProvider.dart';

class AddNewTaskFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;
  final String listType;
  final DateTime selectedDate;
  const AddNewTaskFloatingActionButton({
    super.key,
    required this.keyFab,
    required this.listType,
    required this.selectedDate

  });

  @override
  State<AddNewTaskFloatingActionButton> createState() => _AddNewTaskFloatingActionButtonState();
}

class _AddNewTaskFloatingActionButtonState extends State<AddNewTaskFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    var provider = context.read<GlobalProvider>();
    return FloatingActionButton.small(
      heroTag: "TaskFab",
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNewTaskScreen(taskList: widget.listType, selectedDate: widget.selectedDate,)),
        ).then((_){
          provider.cleanSelectedUsers();
          provider.cleanSelected();
        });
        widget.keyFab.currentState?.toggle();
      },
      child: const Icon(Icons.add),
    );
  }
}