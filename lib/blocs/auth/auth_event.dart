part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String pin;

  const LoggedIn({required this.pin});

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'LoggedIn { token: $pin }';
}

class LoggedOut extends AuthEvent {}

class RemoteAuthUserChanged extends AuthEvent {
  final AppUser? user;

  const RemoteAuthUserChanged({required this.user});
}

// local auth

class CheckLocalAuthAvailable extends AuthEvent {}

class AuthenticateWithLocalAuth extends AuthEvent {}
