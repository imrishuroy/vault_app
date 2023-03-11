import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/constants/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: SignupStatus.initial));
  }

  void bioChanged(String value) {
    emit(state.copyWith(bio: value, status: SignupStatus.initial));
  }

  void showPassword(bool showPassword) {
    emit(state.copyWith(
        showPassword: !showPassword, status: SignupStatus.initial));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      print('Email ${state.email}');
      final userSnaps =
          await _usersRef.where('username', isEqualTo: state.username).get();

      print('User lenght ------ ${userSnaps.docs.length}');

      if (userSnaps.docs.isNotEmpty) {
        emit(state.copyWith(
            status: SignupStatus.error,
            failure: const Failure(message: 'Username already exists')));
        return;
      }

      print('Password ${state.password}');
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: state.email?.trim(),
        password: state.password?.trim(),
      );

      print('User after login attempted -------${user?.uid}');

      if (user != null) {
        // final String? downloadUrl = await ImageUtil.uploadProfileImageToStorage(
        //     'profileImages', state.imageFile!, false, user.uid!);
        final doc = await _usersRef.doc(user.uid).get();

        //final check =   await _usersRef.where('username', isNotEqualTo: user.username).get();

        if (!doc.exists) {
          final appUser = AppUser(
            email: state.email ?? '',
            //   profilePic: downloadUrl ?? '',
            uid: user.uid,
            name: state.name ?? '',
            // username: state.username?.toLowerCase(),
            // bio: state.bio ?? '',
            createdAt: DateTime.now(),
          );

          await _usersRef.doc(user.uid).set(appUser.toMap());
        }
      }

      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }
  }
}
