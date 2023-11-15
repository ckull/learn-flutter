part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSuccessState extends AuthState {
  final User user;

  AuthSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthAuthenticatedState extends AuthState {
  final User user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthUnauthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLogoutState extends AuthState {
  @override
  List<Object> get props => [];
}
