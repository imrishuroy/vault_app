import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/app_user.dart';
import '/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AppUser?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    _userSubscription = _authRepository.onAuthChanges
        .listen((user) => add(RemoteAuthUserChanged(user: user)));

    on<RemoteAuthUserChanged>((event, emit) {
      if (event.user != null) {
        emit(RemoteUserAuthenticated(user: event.user));
      }
    });

    on<AppStarted>((event, emit) async {});
    on<LoggedIn>((event, emit) async {
      emit(LoadingState());
      final result = _authRepository.checkCode(event.pin);

      if (result) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<CheckLocalAuthAvailable>((event, emit) async {
      final bool isAvailable = await _authRepository.checkLocalAuthAvailable();
      print('Local auth available $isAvailable');
      if (isAvailable) {
        emit(LocalAuthAvailable());
      }
    });

    on<AuthenticateWithLocalAuth>((event, emit) async {
      emit(LoadingState());
      final authenticationResult =
          await _authRepository.authenticateWithLocalAuth();

      print('Authentication result $authenticationResult');

      if (authenticationResult) {
        emit(AuthLocalAuthenticated());
      } else {
        print('this runs--');
        emit(LocalAuthError());
      }
    });

    on<LoggedOut>((event, emit) async {
      emit(LoadingState());
      // await _authRepository.deleteToken();

      emit(AuthenticationUnauthenticated());
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
