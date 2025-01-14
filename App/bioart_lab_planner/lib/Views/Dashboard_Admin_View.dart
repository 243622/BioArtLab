import 'package:bioartlab_planner/Components/ExpandableFabStocks.dart';
import 'package:bioartlab_planner/Components/ExpandableFabUsers.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewAnimalFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/SmallFABS/AddNewStockFloatingActionButton.dart';
import 'package:bioartlab_planner/Components/ExpandableFabTasks.dart';
import 'package:bioartlab_planner/Components/SpeedFAB.dart';
import 'package:bioartlab_planner/Views/Stock_List_View.dart';
import 'package:bioartlab_planner/Views/Tasks_List_View.dart';
import 'package:bioartlab_planner/Views/Animal_List_View.dart';
import 'package:bioartlab_planner/Views/User_List_View.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

import '../Components/ExpandableFabAnimals.dart';
import '../Components/SmallFABS/AddNewTaskFloatingActionButton.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({
    super.key,
  });

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GlobalProvider>().getAllTasks();
      context.read<GlobalProvider>().getAllStocks();
      context.read<GlobalProvider>().getAllAnimals();
      context.read<GlobalProvider>().getAllTaskTypes();
      context.read<GlobalProvider>().getAllAnimalTypes();
      context.read<GlobalProvider>().getAllFoodTypes();
      context.read<GlobalProvider>().getAllUsers();
    });
  }

  LoadTasks() async {
    await context.read<GlobalProvider>().getAllTasks();
  }

  Widget _getSelectedPage() {
    switch (context.watch<GlobalProvider>().currentPageDrawer) {
      case 0:
        return TaskListView();
      case 1:
        return AnimalListView();
      case 2:
        return StockListView();
      case 3:
        return UserListView();
      default:
        return TaskListView(); // default view, in case none matches
    }
  }

  Widget _getFloatingButton() {
    switch (context.watch<GlobalProvider>().currentPageDrawer) {
      case 0:
        return ExpandableFabTasks();
      case 1:
        return ExpandableFabAnimals();
      case 2:
        return ExpandableFabStocks();
      case 3:
        return ExpandableFabUsers();
      default:
        return ExpandableFabTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: _getFloatingButton(),
        body: Container(child: _getSelectedPage()));
  }
}
