import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Bird.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Chicken.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Cow.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Goose.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Horse.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Pig.dart';
import 'package:bio_art_planner_v2/Views/User/DierInfo_pages/Sheep.dart';

import '../../Views/Main/Main_View_Admin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerUserComp extends StatefulWidget {
  const DrawerUserComp({super.key});

  @override
  State<DrawerUserComp> createState() => _DrawerUserCompState();
}

class _DrawerUserCompState extends State<DrawerUserComp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).brightness == Brightness.light ? Colors.grey[350] : Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Center items vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
            children: <Widget>[
              // Centered List Items
              Flexible(
                child: ListView(
                  shrinkWrap: true, // Ensures the list only takes the necessary space
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // Subheader 1
                    _buildSubHeader('Animal info'),
                    _buildDrawerItem(
                      context,
                      icon: ImageIcon(AssetImage('Assets/icons/icons8-sheep-50.png')),
                      text: 'Sheep',
                      onTap: () => navigateToSheep(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: FaIcon(FontAwesomeIcons.cow, size: 20),
                      text: 'Cow',
                      onTap: () => navigateToCow(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: FaIcon(FontAwesomeIcons.horse, size: 20),
                      text: 'Horse',
                      onTap: () => navigateToHorse(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: ImageIcon(AssetImage('Assets/icons/icons8-pig-50.png')),
                      text: 'Pig',
                      onTap: () => navigateToPig(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: ImageIcon(AssetImage('Assets/icons/icons8-swan-50.png')),
                      text: 'Goose',
                      onTap: () => navigateToGoose(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: ImageIcon(AssetImage('Assets/icons/chicken.png')),
                      text: 'Chicken',
                      onTap: () => navigateToChicken(),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: FaIcon(FontAwesomeIcons.dove, size: 20),
                      text: 'Bird',
                      onTap: () => navigateToBird(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required dynamic icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[300] : Colors.grey[800],
        splashColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[700],
        child: ListTile(
          leading: icon is IconData ? Icon(icon, size: 20) : icon,
          title: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void navigateWithSlideTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Slide in from bottom
          const end = Offset.zero;       // Final position
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void navigateToSheep() {
    navigateWithSlideTransition(context, const SheepInfoPage());
  }

  void navigateToCow() {
    navigateWithSlideTransition(context, const CowInfoPage());
  }

  void navigateToHorse() {
    navigateWithSlideTransition(context, const HorseInfoPage());
  }

  void navigateToPig() {
    navigateWithSlideTransition(context, const PigInfoPage());
  }

  void navigateToGoose() {
    navigateWithSlideTransition(context, const GooseInfoPage());
  }

  void navigateToChicken() {
    navigateWithSlideTransition(context, const ChickenInfoPage());
  }

  void navigateToBird() {
    navigateWithSlideTransition(context, const BirdInfoPage());
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
}