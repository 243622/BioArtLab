import '/Components/SmallFABS/AddNewTaskFloatingActionButton.dart';
import '/Components/SmallFABS/AddNewTaskTypeFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExpandableFabTasks extends StatefulWidget {
  final String listType;
  final DateTime selectedDate;
  const ExpandableFabTasks({
    super.key,
    required this.listType,
    required this.selectedDate
  });



  @override
  State<ExpandableFabTasks> createState() => _ExpandableFabTasksState();
}

class _ExpandableFabTasksState extends State<ExpandableFabTasks> {
  final _key = GlobalKey<ExpandableFabState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      overlayStyle: ExpandableFabOverlayStyle(
          blur: 5
      ),
      type: ExpandableFabType.up,
      key: _key,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        heroTag: "ExpandableFabTasks",
        child: const Icon(Icons.add),
      ),
      children: [
        Row(
          children: [
            const Text('Add new task'),
            const SizedBox(width: 20),
            AddNewTaskFloatingActionButton(keyFab: _key, listType: widget.listType, selectedDate: widget.selectedDate,),
          ],
        ),
        Row(
          children: [
            const Text('Add new task type'),
            const SizedBox(width: 20),
            AddNewTaskTypeFloatingActionButton(keyFab: _key)
          ],
        ),
      ],
    );
  }
}
