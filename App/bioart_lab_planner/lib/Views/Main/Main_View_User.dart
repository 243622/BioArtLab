import 'package:bioartlab_planner/Views/Dashboard_User_View.dart';
import 'package:bioartlab_planner/Views/Main/Main_View.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainViewUser extends StatefulWidget {
  const MainViewUser({super.key});

  @override
  State<MainViewUser> createState() => _MainViewUserState();
}

class _MainViewUserState extends State<MainViewUser> {
  @override
  late PageController pageController;
  int selectedIndex = 0;
  Map user = {};

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
    if (selectedIndex == 2) {
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
      drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notificaties"),
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
            DashBoardUser(),
          ]),
    );
  }
}
