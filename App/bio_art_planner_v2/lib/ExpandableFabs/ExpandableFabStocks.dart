import '/Components/SmallFABS/AddNewFoodTypeFloatingActionButton.dart';
import '/Components/SmallFABS/AddNewStockFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExpandableFabStocks extends StatefulWidget {

  const ExpandableFabStocks({super.key});

  @override
  State<ExpandableFabStocks> createState() => _ExpandableFabStocksState();
}

class _ExpandableFabStocksState extends State<ExpandableFabStocks> {
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
      overlayStyle: ExpandableFabOverlayStyle(
          blur: 5
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        heroTag: "ExpandableFabStocks"
      ),
      children: [
        Row(
          children: [
            const Text('Add new stock'),
            const SizedBox(width: 20),
            AddNewStockFloatingActionButton(keyFab: _key,),
          ],
        ),
        Row(
          children: [
            const Text('Add new food type'),
            const SizedBox(width: 20),
            AddNewFoodTypeFloatingActionButton(keyFab: _key)
          ],
        ),
      ],
    );
  }
}
