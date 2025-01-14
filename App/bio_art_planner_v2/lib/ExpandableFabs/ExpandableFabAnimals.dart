import '/Components/SmallFABS/AddNewAnimalFloatingActionButton.dart';
import '/Components/SmallFABS/AddNewAnimalTypeFloatingActionButton.dart';
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
      overlayStyle: ExpandableFabOverlayStyle(
          blur: 5
      ),
      type: ExpandableFabType.up,
      key: _key,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        heroTag: "ExpandableFabAnimals"
      ),
      children: [
        Row(
          children: [
            const Text('Add new animal'),
            const SizedBox(width: 20),
            AddNewAnimalFloatingActionButton(keyFab: _key,),
          ],
        ),
        Row(
          children: [
            const Text('Add new animal type'),
            const SizedBox(width: 20),
            AddNewAnimalTypeFloatingActionButton(keyFab: _key)
          ],
        ),
      ],
    );
  }
}
