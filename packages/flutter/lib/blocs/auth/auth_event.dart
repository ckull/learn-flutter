part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthIdleEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthLoadUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthLogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthLoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [];
}

class AuthAuthenticatedEvent extends AuthEvent {
  final dynamic user;

  AuthAuthenticatedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticatedEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthErrorEvent extends AuthEvent {
  final String message;

  AuthErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}
