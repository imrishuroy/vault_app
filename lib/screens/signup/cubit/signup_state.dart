part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String? email;
  final String? name;
  final String? username;
  final String? password;
  final SignupStatus status;
  final Failure failure;
  final String? uid;
  final String? bio;
  final bool showPassword;

  bool get isFormValid => email!.isNotEmpty && password!.isNotEmpty;

  const SignupState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
    required this.name,
    required this.username,
    required this.showPassword,
    required this.uid,
    required this.bio,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      name: '',
      username: '',
      status: SignupStatus.initial,
      failure: Failure(),
      showPassword: false,
      uid: '',
      bio: '',
    );
  }

  SignupState copyWith({
    String? email,
    String? name,
    String? username,
    String? password,
    SignupStatus? status,
    Failure? failure,
    bool? showPassword,
    String? uid,
    String? bio,
  }) {
    return SignupState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      showPassword: showPassword ?? this.showPassword,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'SignupState(email: $email, name: $name, username: $username, password: $password, status: $status, failure: $failure, uid: $uid, bio: $bio, showPassword: $showPassword)';
  }

  @override
  List<Object?> get props {
    return [
      email,
      name,
      username,
      password,
      status,
      failure,
      uid,
      bio,
      showPassword,
    ];
  }
}
