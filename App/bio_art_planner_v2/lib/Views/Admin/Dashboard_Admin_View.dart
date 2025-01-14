
import 'package:bio_art_planner_v2/models/services/AnimalTypeServices.dart';
import 'package:bio_art_planner_v2/models/services/FoodTypeServices.dart';
import 'package:bio_art_planner_v2/models/services/TaskServices.dart';
import 'package:bio_art_planner_v2/models/services/UserServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/Foodtype_AnimalServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/User_MessageServices.dart';
import 'package:bio_art_planner_v2/models/services/many_many/User_TaskServices.dart';

import '../../ExpandableFabs/ExpandableFabStocks.dart';
import '../../ExpandableFabs/ExpandableFabUsers.dart';
import '../../ExpandableFabs/ExpandableFabTasks.dart';
import 'Stock_List_View.dart';
import 'Tasks_List_View.dart';
import 'Animal_List_View.dart';
import 'User_List_View.dart';
import '../../models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

import '../../ExpandableFabs/ExpandableFabAnimals.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({
    super.key,
  });

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  UserTaskServices userTaskServices = UserTaskServices();
  UserServices userServices = UserServices();
  TaskServices taskServices = TaskServices();

  FoodTypeServices foodTypeServices = FoodTypeServices();
  AnimalTypeServices animalTypeServices = AnimalTypeServices();
  FoodTypeAnimalServices foodtypeAnimalServices = FoodTypeAnimalServices();
  UserMessageServices userMessageServices = UserMessageServices();
  @override
  void initState() {
      // TODO: implement initState
    super.initState();
    Future.microtask(() {

    });
  }

  Widget _getSelectedPage() {
    switch (context.watch<GlobalProvider>().currentPageDrawer) {
      case 0:
        return const TaskListView();
      case 1:
        return const AnimalListView();
      case 2:
        return const StockListView();
      case 3:
        return const UserListView();
      default:
        return const TaskListView(); // default view, in case none matches
    }
  }

  Widget _getFloatingButton() {
    switch (context.watch<GlobalProvider>().currentPageDrawer) {
      case 0:
        return  ExpandableFabTasks(listType: "allTasks", selectedDate: DateTime.now(),);
      case 1:
        return const ExpandableFabAnimals();
      case 2:
        return const ExpandableFabStocks();
      case 3:
        return const ExpandableFabUsers();
      default:
        return  ExpandableFabTasks(listType: "allTasks", selectedDate: DateTime.now(),);
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
