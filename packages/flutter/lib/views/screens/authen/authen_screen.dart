import 'package:flutter/material.dart';
import 'package:first_project/views/screens/authen/types/enums.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:first_project/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  final AuthenType authType;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthPage({Key? key, required this.authType}) : super(key: key);

  void handleLogin(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    print(username + password);

    authBloc.add(AuthLoginEvent(username: username, password: password));
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    Widget buildForm() {
      return FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'username',
              decoration: InputDecoration(
                labelText: 'username',
                hintText: 'Enter your username',
              ),
              controller: usernameController,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'username is required'),
              ]),
            ),
            SizedBox(height: 16),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              controller: passwordController,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Password is required'),
                FormBuilderValidators.minLength(6),
              ]),
            ),
            SizedBox(height: 24),
            //full width button
            getButton(context, authType)
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(getAppBarTitle(authType)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            24.0,
          ),
          child: buildForm(),
        ));
  }

  String getAppBarTitle(AuthenType authType) {
    switch (authType) {
      case AuthenType.login:
        return 'Login';
      case AuthenType.register:
        return 'Register';
      case AuthenType.forgotPassword:
        return 'Forgot Password';
      default:
        return '';
    }
  }

  List<dynamic> getForms(BuildContext context, AuthenType authType) {
    switch (authType) {
      case AuthenType.login:
        return getLoginForm(context, authType);
      case AuthenType.register:
        return getRegisterForm(context, authType);
      case AuthenType.forgotPassword:
        return getForgotPasswordForm(context, authType);
      default:
        return [];
    }
  }

  getButton(BuildContext context, AuthenType authType) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    switch (authType) {
      case AuthenType.login:
        {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Container(
                  child: Column(
                children: [
                  if (state is AuthErrorState) Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        // print(_formKey.currentState!.value);
                        handleLogin(context);
                      }
                    },
                    child: (state is AuthLoadingState)
                        ? CircularProgressIndicator()
                        : Text('Login'),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register'))
                ],
              ));
            },
          );
        }
      case AuthenType.register:
        {
          return Container(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  print(_formKey.currentState!.value);
                }
              },
              child: Text('Register'),
            ),
          );
        }
      case AuthenType.forgotPassword:
        {
          return Container(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  print(_formKey.currentState!.value);
                }
              },
              child: Text('Reset Password'),
            ),
          );
        }
    }
  }

  List<dynamic> getLoginForm(BuildContext context, AuthenType authType) {
    return [
      FormBuilderTextField(
        name: 'username',
        decoration: InputDecoration(
          labelText: 'username',
          hintText: 'Enter your username',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'username is required'),
        ]),
      ),
      SizedBox(height: 16),
      FormBuilderTextField(
        name: 'password',
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Password is required'),
          FormBuilderValidators.minLength(6),
        ]),
      ),
      SizedBox(height: 24),
      getButton(context, authType)
    ];
  }

  List<dynamic> getRegisterForm(BuildContext context, AuthenType authType) {
    return [
      FormBuilderTextField(
        name: 'name',
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Enter your name',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Name is required'),
        ]),
      ),
      FormBuilderTextField(
        name: 'username',
        decoration: InputDecoration(
          labelText: 'username',
          hintText: 'Enter your username',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'username is required'),
        ]),
      ),
      SizedBox(height: 16),
      FormBuilderTextField(
        name: 'password',
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Password is required'),
          FormBuilderValidators.minLength(6),
        ]),
      ),
      SizedBox(height: 24),
      getButton(context, authType)
    ];
  }

  List<dynamic> getForgotPasswordForm(
      BuildContext context, AuthenType authType) {
    return [
      FormBuilderTextField(
        name: 'username',
        decoration: InputDecoration(
          labelText: 'username',
          hintText: 'Enter your username',
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'username is required'),
        ]),
      ),
      SizedBox(height: 24),
      getButton(context, authType)
    ];
  }
}
