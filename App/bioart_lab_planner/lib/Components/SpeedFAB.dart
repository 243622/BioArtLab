import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class TestSpeedFab extends StatefulWidget {
  const TestSpeedFab({super.key});

  @override
  State<TestSpeedFab> createState() => _TestSpeedFabState();
}

class _TestSpeedFabState extends State<TestSpeedFab> {
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      children: const [
        Row(
          children: [
            Text('Remind'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.notifications),
            ),
          ],
        ),
        Row(
          children: [
            Text('Email'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.email),
            ),
          ],
        ),
        Row(
          children: [
            Text('Star'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.star),
            ),
          ],
        ),
      ],
    );
  }
}
