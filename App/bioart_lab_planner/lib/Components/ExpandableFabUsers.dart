import 'package:bioartlab_planner/Components/SmallFABS/AddNewAnimalFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewAnimalTypeFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewFoodTypeFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewStockFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewTaskTypeFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewUserFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExpandableFabUsers extends StatefulWidget {

  const ExpandableFabUsers({super.key});

  @override
  State<ExpandableFabUsers> createState() => _ExpandableFabUsersState();
}

class _ExpandableFabUsersState extends State<ExpandableFabUsers> {
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
            Text('Add new User'),
            SizedBox(width: 20),
            AddNewUserFloatingActionButton(keyFab: _key,),
          ],
        ),
      ],
    );;
  }
}
