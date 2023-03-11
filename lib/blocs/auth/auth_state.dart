part of 'auth_bloc.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingState extends AuthState {}

class AuthenticationUninitialized extends AuthState {}

class AuthenticationAuthenticated extends AuthState {}

class AuthenticationUnauthenticated extends AuthState {}

class LocalAuthAvailable extends AuthState {}

class AuthLocalAuthenticated extends AuthState {}

class LocalAuthError extends AuthState {}

class RemoteUserAuthenticated extends AuthState {
  final AppUser? user;

  RemoteUserAuthenticated({required this.user});
}
