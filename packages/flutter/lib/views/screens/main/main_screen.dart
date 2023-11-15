import 'package:flutter/material.dart';
import 'package:first_project/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_project/views/screens/layout/layout_screen.dart';
import 'package:first_project/views/screens/authen/authen_screen.dart';
import 'package:first_project/views/screens/authen/types/enums.dart';
import 'package:first_project/views/screens/unauthen/unauthen_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticatedState) {
        return AuthenticatedLayout();
      } else if (state is AuthUnauthenticatedState) {
        return UnauthenScreen();
      } else if (state is AuthLoadingState) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
