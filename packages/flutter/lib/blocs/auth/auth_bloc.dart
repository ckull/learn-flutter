import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:first_project/models/user_model.dart';
import 'package:first_project/services/auth_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthLoadingState()) {
    on<AuthLoadUserEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        User user = await AuthService.loadUser();
        emit(AuthAuthenticatedState(user: user));
      } catch (e) {
        emit(AuthUnauthenticatedState());
      }
    });

    on<AuthAuthenticatedEvent>((event, emit) {
      emit(AuthSuccessState(user: event.user));
    });

    on<AuthUnauthenticatedEvent>((event, emit) {
      emit(AuthUnauthenticatedState());
    });

    on<AuthLoginEvent>((event, emit) async {
      try {
        dynamic user = await AuthService.login(
          username: event.username,
          password: event.password,
        );

        emit(AuthAuthenticatedState(user: user));
        AuthService.saveTokens(user.tokens);
      } catch (err) {
        emit(AuthErrorState(message: err.toString()));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      try {
        await AuthService.logout();
        emit(AuthUnauthenticatedState());
      } catch (err) {
        emit(AuthErrorState(message: err.toString()));
      }
    });

    add(AuthLoadUserEvent());
  }
}
