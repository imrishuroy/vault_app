part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, loading, success, error }

class LoginState extends Equatable {
  final String pin;
  final Failure failure;
  final bool pinAvailable;
  final LoginStatus status;
  final String email;
  final String password;
  final bool showPassword;

  const LoginState({
    required this.pin,
    required this.failure,
    this.pinAvailable = false,
    required this.status,
    required this.email,
    required this.password,
    required this.showPassword,
  });

  bool get formvalid => pin.isNotEmpty;

  bool get isRemoteFormValid => email.isNotEmpty && password.isNotEmpty;

  factory LoginState.initial() => const LoginState(
        pin: '',
        failure: Failure(),
        status: LoginStatus.initial,
        pinAvailable: false,
        email: '',
        password: '',
        showPassword: false,
      );

  @override
  List<Object> get props => [
        pin,
        failure,
        status,
        email,
        password,
        showPassword,
      ];

  LoginState copyWith({
    String? pin,
    Failure? failure,
    LoginStatus? status,
    bool? pinAvailable,
    String? email,
    String? password,
    bool? showPassword,
  }) {
    return LoginState(
      pin: pin ?? this.pin,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      pinAvailable: pinAvailable ?? this.pinAvailable,
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
    );
  }

  @override
  String toString() {
    return 'LoginState(pin: $pin, failure: $failure, pinAvailable: $pinAvailable, status: $status, email: $email, password: $password, showPassword: $showPassword)';
  }
}
