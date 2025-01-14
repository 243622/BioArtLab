import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskTypeFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExpandableFabTasks extends StatefulWidget {

  const ExpandableFabTasks({super.key});

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
      type: ExpandableFabType.up,
      key: _key,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
      ),
      children: [
        Row(
          children: [
            Text('Add new task'),
            SizedBox(width: 20),
            AddNewTaskFloatingActionButton(keyFab: _key,),
          ],
        ),
        Row(
          children: [
            Text('Add new task type'),
            SizedBox(width: 20),
            AddNewTaskTypeFloatingActionButton(keyFab: _key)
          ],
        ),
        Row(
          children: [
            Text('Add a new template'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.file_copy),
            ),
          ],
        ),
      ],
    );;
  }
}
