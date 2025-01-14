import 'package:bioartlab_planner/Views/Dashboard_Admin_View.dart';
import 'package:bioartlab_planner/Views/Dashboard_User_View.dart';
import 'package:bioartlab_planner/Views/Login_View.dart';
import 'package:bioartlab_planner/Views/Main/Main_View_Admin.dart';
import 'package:bioartlab_planner/Views/Main/Main_View_User.dart';
import 'package:bioartlab_planner/models/classes/User.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:bioartlab_planner/models/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  }

  sucessfullLogin(int index) async {
    if (index == 0) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MainViewAdmin(),
        ),
      );
    } else {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MainViewUser(),
        ),
      );
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
