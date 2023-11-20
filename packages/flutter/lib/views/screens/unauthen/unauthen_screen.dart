import 'package:flutter/material.dart';
import 'package:first_project/views/screens/authen/authen_screen.dart';
import 'package:first_project/views/screens/authen/types/enums.dart';

class UnauthenScreen extends StatefulWidget {
  const UnauthenScreen({Key? key}) : super(key: key);

  @override
  _UnauthenScreenState createState() => _UnauthenScreenState();
}

class _UnauthenScreenState extends State<UnauthenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
                builder: (_) => AuthPage(authType: AuthenType.login));
          case '/register':
            return MaterialPageRoute(
                builder: (_) => AuthPage(authType: AuthenType.register));
          default: // '/login'
            return MaterialPageRoute(
                builder: (_) => AuthPage(authType: AuthenType.login));
        }
      },
    ));
  }
}
