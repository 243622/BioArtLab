import 'package:bio_art_planner_v2/Themes/Dark_theme.dart';
import 'package:bio_art_planner_v2/Themes/Light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Views/Main/Main_View.dart';
import 'models/globalProvider.dart';
import 'models/services/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  runApp(
      ChangeNotifierProvider(
        create: (context) => GlobalProvider(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override


  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const MainView(),
    );
  }
}



