import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerComp extends StatefulWidget {
  const DrawerComp({super.key});

  @override
  State<DrawerComp> createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: <Widget>[
            const Spacer(),
            Expanded(
              flex: 2,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  _buildDrawerItem(
                    context,
                    icon: Icons.task,
                    text: 'Tasks',
                    onTap: () => _navigateToPage(context, 0),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.catching_pokemon,
                    text: 'Animals',
                    onTap: () => _navigateToPage(context, 1),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.folder,
                    text: 'Stocks',
                    onTap: () => _navigateToPage(context, 2),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    text: 'Users',
                    onTap: () => _navigateToPage(context, 3),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.transparent, // Ensures background color is the drawer's color
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.grey[800], // Hover color for feedback
        splashColor: Colors.grey[700], // Splash color on tap
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 20),
          title: Text(
            text,
            textAlign: TextAlign.center, // Center align the text
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int pageIndex) {
    context.read<GlobalProvider>().changePageDrawer(pageIndex);
    Navigator.pop(context);
  }
}
