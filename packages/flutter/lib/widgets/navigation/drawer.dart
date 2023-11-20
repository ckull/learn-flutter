import 'package:first_project/views/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatefulWidget {
  final List<Map<String, dynamic>> menuList;
  final int selectedIndex;
  final Function onTapped;

  const DrawerMenu({
    Key? key,
    required this.menuList,
    required this.selectedIndex,
    required this.onTapped,
  }) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        for (int i = 0; i < widget.menuList.length; i++)
          ListTile(
            title: Text(widget.menuList[i]['title']!),
            selected: widget.selectedIndex == i,
            onTap: () => widget.onTapped(i),
          ),
      ],
    ));
  }
}
