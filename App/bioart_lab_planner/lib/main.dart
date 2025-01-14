import 'package:bioartlab_planner/Views/Login_View.dart';
import 'package:bioartlab_planner/Views/Main/Main_View.dart';
import 'package:bioartlab_planner/Views/Main/Main_View_Admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/globalProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalProvider(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainView()
    );
  }
}
