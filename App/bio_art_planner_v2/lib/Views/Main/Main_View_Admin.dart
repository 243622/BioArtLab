import 'package:bio_art_planner_v2/Views/Admin/Calender_Admin_View.dart';

import '/Components/Drawer.dart';
import '../Admin/Dashboard_Admin_View.dart';
import '/Views/Main/Main_View.dart';
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

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
    Future.microtask(() {
      context.read<GlobalProvider>().getRapportByDate(DateTime.now());
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  getCurrentUser() async {
    user = context.read<GlobalProvider>().currentUser;
    user.toString();
  }

  void changeView(int index) {
    if (pageController.hasClients && !pageController.position.isScrollingNotifier.value) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.read<GlobalProvider>().currentUser["username"].toString()),
        centerTitle: true,
      ),
      drawer: selectedIndex == 1 ? DrawerComp() : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calender"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_add), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Uitloggen")
        ],
        currentIndex: selectedIndex,
        onTap: changeView,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          CalenderAdminView(),
          DashboardAdmin(),
        ],
      ),
    );
  }
}