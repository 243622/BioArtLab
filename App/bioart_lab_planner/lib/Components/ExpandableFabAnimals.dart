import 'package:bioartlab_planner/Components/SmallFABS/AddNewAnimalFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewAnimalTypeFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskTypeFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExpandableFabAnimals extends StatefulWidget {

  const ExpandableFabAnimals({super.key});

  @override
  State<ExpandableFabAnimals> createState() => _ExpandableFabAnimalsState();
}

class _ExpandableFabAnimalsState extends State<ExpandableFabAnimals> {
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
            Text('Add new animal'),
            SizedBox(width: 20),
            AddNewAnimalFloatingActionButton(keyFab: _key,),
          ],
        ),
        Row(
          children: [
            Text('Add new animal type'),
            SizedBox(width: 20),
            AddNewAnimalTypeFloatingActionButton(keyFab: _key)
          ],
        ),
      ],
    );;
  }
}
