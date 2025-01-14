import '/Components/SmallFABS/AddNewTaskFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../Components/SmallFABS/ZieRapportenFloatingActionButton.dart';

class ExpandableFabCalender extends StatefulWidget {
  final String listType;
  final DateTime selectedDate;
  const ExpandableFabCalender({
    super.key,
    required this.listType,
    required this.selectedDate

  });

  @override
  State<ExpandableFabCalender> createState() => _ExpandableFabCalenderState();
}

class _ExpandableFabCalenderState extends State<ExpandableFabCalender> {
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
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 5
      ),
      key: _key,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        heroTag: "ExpandableFabCalender"
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
            const Text('Zie rapporten van vandaag'),
            const SizedBox(width: 20),
            RapportsFloatingActionButton(keyFab: _key, selectedDate: widget.selectedDate,)
          ],
        ),
      ],
    );
  }
}
