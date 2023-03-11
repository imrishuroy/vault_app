import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/constants/paths.dart';
import '/models/failure.dart';
import '/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState.initial());

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  void pinChanged(String pin) {
    emit(state.copyWith(pin: pin, status: LoginStatus.initial));
  }

  void checkPinAvailable() {
    final result = _authRepository.pinAvailable();
    emit(state.copyWith(pinAvailable: result, status: LoginStatus.initial));
  }

  void setPin() async {
    await _authRepository.setAppCode(state.pin);
    emit(state.copyWith(status: LoginStatus.success));
  }

  void submitPin() {
    emit(state.copyWith(status: LoginStatus.loading));

    if (state.formvalid) {
      final result = _authRepository.checkCode(state.pin);

      if (result) {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(
          LoginState(
            pin: state.pin,
            failure: const Failure(message: 'Invalid pin'),
            status: LoginStatus.error,
            email: '',
            password: '',
            showPassword: false,
          ),
        );
      }
    }
  }

  // remote login
  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void showPassword(bool showPassword) {
    emit(state.copyWith(
        showPassword: !showPassword, status: LoginStatus.initial));
  }

  void signInWithEmail() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.loginInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: LoginStatus.error));
    }
  }

  void signUpWithEmail() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      if (user != null) {
        final doc = await _usersRef.doc(user.uid).get();
        if (!doc.exists) {
          _usersRef.doc(user.uid).set(user.toMap());
        }
      }

      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: LoginStatus.error));
    }
  }
}
