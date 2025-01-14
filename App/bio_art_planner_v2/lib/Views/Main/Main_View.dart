
import 'package:provider/provider.dart';

import '../../models/globalProvider.dart';
import '/Views/Login_View.dart';
import 'Main_View_Admin.dart';
import '/Views/Main/Main_View_User.dart';
import '/models/services/UserServices.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<GlobalProvider>().getAllStocks();
      context.read<GlobalProvider>().getAllTaskTypes();
      context.read<GlobalProvider>().getAllFoodTypes();
      context.read<GlobalProvider>().getAllUsers();
      context.read<GlobalProvider>().getAllAnimalTypes();
    });
  }
  void navigateToAdmin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainViewAdmin(),
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
      ),
    );
  }

  void navigateToUser() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainViewUser(),
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
      ),
    );
  }

  sucessfullLogin(int index) async {
    if (index == 0) {
      navigateToAdmin();

    } else {
      navigateToUser();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginView(
        onLoginSuccessUser: () => sucessfullLogin(1),
        onLoginSuccessAdmin: () => sucessfullLogin(0),
      ),
    );
  }
}
