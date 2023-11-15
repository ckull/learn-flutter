import 'package:first_project/widgets/navigation/drawer.dart';
import 'package:flutter/material.dart';
import 'package:first_project/views/screens/authen/authen_screen.dart';
import 'package:first_project/views/screens/authen/types/enums.dart';
import 'package:first_project/views/screens/home/home_screen.dart';
import 'package:first_project/services/auth_service.dart';
import 'package:first_project/views/screens/feature/feature_screen.dart';
import 'package:first_project/views/screens/setting/setting_screen.dart';
import 'package:first_project/widgets/navigation/drawer.dart';

const menuList = [
  {
    'title': 'Home',
    'route': '/',
  },
  {
    'title': 'Feature',
    'route': '/feature',
  },
  {
    'title': 'Setting',
    'route': '/setting',
  },
];

class AuthenticatedLayout extends StatefulWidget {
  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamed(context, menuList[index]['route']!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Authenticated Layout')),
        body: Navigator(
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => const HomeScreen());
              case '/feature':
                return MaterialPageRoute(builder: (_) => const FeatureScreen());
              case '/setting':
                return MaterialPageRoute(builder: (_) => const SettingScreen());
              default:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
          },
        ),
        drawer: DrawerMenu(
            menuList: menuList,
            onTapped: _onItemTapped,
            selectedIndex: _selectedIndex),
      ),
    );
  }
}
