import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/AK.jpeg'),
            ),
            accountName: Text("Vigneshwar Raja"),
            accountEmail: Text("vigneshwarraja@scodesoft.com"),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text("Categories"),
            leading: Icon(Icons.view_list),
            onTap: () {
              Navigator.pushNamed(context, '/categories');
            },
          )
        ],
      ),
    );
  }
}
