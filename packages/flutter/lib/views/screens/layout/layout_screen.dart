import 'package:first_project/widgets/navigation/drawer.dart';
import 'package:flutter/material.dart';
import 'package:first_project/views/screens/authen/authen_screen.dart';
import 'package:first_project/views/screens/authen/types/enums.dart';
import 'package:first_project/views/screens/home/home_screen.dart';
import 'package:first_project/services/auth_service.dart';
import 'package:first_project/views/screens/feature/feature_screen.dart';
import 'package:first_project/views/screens/setting/setting_screen.dart';
import 'package:first_project/widgets/navigation/drawer.dart';

const List<Map<String, dynamic>> menuList = [
  {
    'title': 'Home',
    'route': '/home',
    'element': HomeScreen(),
  },
  {
    'title': 'Feature',
    'route': '/feature',
    'element': FeatureScreen(),
  },
  {
    'title': 'Setting',
    'route': '/setting',
    'element': SettingScreen(),
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
    // Navigator.pushNamed(context, (menuList[index]['route'] as String));

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authenticated Layout')),
      body: menuList[_selectedIndex]['element'],
      // body: Navigator(
      //   onGenerateRoute: (settings) {
      //     switch (settings.name) {
      //       case '/home':
      //         return MaterialPageRoute(builder: (_) => HomeScreen());
      //       case '/feature':
      //         return MaterialPageRoute(builder: (_) => FeatureScreen());
      //       case '/setting':
      //         return MaterialPageRoute(builder: (_) => SettingScreen());
      //       default: // '/home'
      //         return MaterialPageRoute(builder: (_) => HomeScreen());
      //     }
      //   },
      // ),
      drawer: DrawerMenu(
        menuList: menuList,
        selectedIndex: _selectedIndex,
        onTapped: _onItemTapped,
      ),
    );
  }
}
