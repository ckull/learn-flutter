import 'package:first_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_project/blocs/auth/auth_bloc.dart';
import 'package:first_project/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          child: Column(children: [
            Text('Home Screen'),
            if (state is AuthAuthenticatedState) Text(state.user.toJson()),
            ElevatedButton(
              onPressed: () {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                authBloc.add(AuthLogoutEvent());
              },
              child: Text('Logout'),
            ),
          ]),
        );
      },
    );
  }
}
