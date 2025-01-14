import 'package:bio_art_planner_v2/Views/User/UserRapport_Screen.dart';

import '../../Components/User/DrawerUser.dart';
import '../Settings_View.dart';
import '../User/Dashboard_User_View.dart';
import '/Views/Main/Main_View.dart';
import '/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainViewUser extends StatefulWidget {
  const MainViewUser({super.key});

  @override
  State<MainViewUser> createState() => _MainViewUserState();
}

class _MainViewUserState extends State<MainViewUser> {
  @override

  //!TODO Maak de rest van de tekst op deze scherm translatebaar
  late PageController pageController;
  int selectedIndex = 0;
  Map user = {};

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(initialPage: 0);
    super.initState();
    // Future.microtask((){;
    //   for(var stock in context.read<GlobalProvider>().allStocks){
    //     if(stock.minimumQuantity! >= stock.quantity!){
    //       NotificationService().showNotification(0, "Stock: ${stock.foodTypeInString}, moet bijbesteld worden", "Stocks current quantity: ${stock.quantity}, minimum allowed: ${stock.minimumQuantity}", null);
    //     }
    //   }
    // });
  }

  getCurrentUser() async {
    user = context.watch<GlobalProvider>().currentUser;
    user.toString();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MainView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
      Navigator.of(context).push(_createRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerUserComp(),
      appBar: AppBar(
        title: Text(
            context.read<GlobalProvider>().currentUser["username"].toString()),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsView(),
              ),
            ).whenComplete((){
               context.read<GlobalProvider>().getUserTasksByUserIdForToday(
                  context.read<GlobalProvider>().currentUser["userId"], context.read<GlobalProvider>().usersLanguage);
            });
          }, icon: Icon(Icons.settings))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notificaties",),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Uitloggen")
        ],
        currentIndex: selectedIndex,
        onTap: changeView,
      ),
      body: PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: const [
            DashBoardUser(),
          ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserRapportScreen(),
          ),
        );
      },
        label: Text("Make a daily rapport"), icon: Icon(Icons.add),)

      ,
    );
  }
}
