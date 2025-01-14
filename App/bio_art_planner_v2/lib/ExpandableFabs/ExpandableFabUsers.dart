import '/Components/SmallFABS/AddNewUserFloatingActionButton.dart';
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
        overlayStyle: ExpandableFabOverlayStyle(
            blur: 5
        ),
      type: ExpandableFabType.up,
      key: _key,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        heroTag: "ExpandableFabUsers"
      ),
      children: [
        Row(
          children: [
            const Text('Add new User'),
            const SizedBox(width: 20),
            AddNewUserFloatingActionButton(keyFab: _key,),
          ],
        ),
      ],
    );
  }
}
