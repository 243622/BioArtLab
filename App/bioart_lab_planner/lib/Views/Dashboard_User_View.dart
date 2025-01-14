import 'package:flutter/material.dart';

class DashBoardUser extends StatefulWidget {
  const DashBoardUser({super.key});

  @override
  State<DashBoardUser> createState() => _DashBoardUserState();
}

class _DashBoardUserState extends State<DashBoardUser> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("User dashbaord"),
    );
  }
}
