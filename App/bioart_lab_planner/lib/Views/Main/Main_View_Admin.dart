import 'package:bioartlab_planner/Components/Drawer.dart';
import 'package:bioartlab_planner/Views/Dashboard_Admin_View.dart';
import 'package:bioartlab_planner/Views/Main/Main_View.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/globalProvider.dart';

class MainViewAdmin extends StatefulWidget {
  const MainViewAdmin({super.key});

  @override
  State<MainViewAdmin> createState() => _MainViewAdminState();
}

class _MainViewAdminState extends State<MainViewAdmin> {
  @override
  Map user = {};
  String selectedPage = '';
  int selectedIndex = 0;
  late PageController pageController;

  void initState() {
    // TODO: implement initState
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  getCurrentUser() async {
    user = context.watch<GlobalProvider>().currentUser;
    user.toString();
  }

  void changeView(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (selectedIndex == 3) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MainView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.read<GlobalProvider>().currentUser["username"].toString()),
        centerTitle: true,
      ),
      drawer: DrawerComp(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calender"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Uitloggen")
        ],
        backgroundColor: Colors.grey[900],
        currentIndex: selectedIndex,
        onTap: changeView,
        selectedItemColor: Colors.white,
      ),
      body: PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            DashboardAdmin(),
          ]),
    );
  }
}
