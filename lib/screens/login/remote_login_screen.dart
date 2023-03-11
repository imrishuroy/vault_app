import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/repositories/auth/auth_repository.dart';
import '/screens/forget-password/forget_password_screen.dart';
import '/screens/login/cubit/login_cubit.dart';
import '/screens/signup/remote_signup_screen.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snackbar.dart';

class RemoteLoginScreen extends StatelessWidget {
  static const String routeName = '/remote-login';

  RemoteLoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: RemoteLoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().signInWithEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canvas = MediaQuery.of(context).size;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        } else if (state.status == LoginStatus.success) {
          Navigator.of(context).pop();
          ShowSnackBar.showSnackBar(context, title: 'Login Succussfull');
        }
      },
      builder: (context, state) {
        return Scaffold(
          // backgroundColor: Colors.transparent,
          body: state.status == LoginStatus.submitting
              ? const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: LoadingIndicator(),
                )
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 22.0, left: 20.0, right: 20.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 30.0),
                          Image.asset(
                            'assets/images/vault-icon.png',
                            height: 80.0,
                            width: 80.0,
                          ),
                          const SizedBox(height: 30.0),
                          const Text(
                            'Secrect Vault',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'Login To BackUp Your Data',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontStyle: FontStyle.italic,
                              //fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: canvas.height * 0.07),
                          CustomTextField(
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
                            validator: (value) =>
                                !(value!.contains('@gmail.com'))
                                    ? 'Invalid Email'
                                    : null,
                            labelText: 'Email',
                            textInputType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail,
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextField(
                            maxLines: 1,
                            isPassowrdField: !state.showPassword,
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            validator: (value) =>
                                value!.length < 6 ? 'Password too short' : null,
                            labelText: 'Password',
                            textInputType: TextInputType.emailAddress,
                            suffixIcon: IconButton(
                              color: Colors.grey.shade500,
                              icon: Icon(
                                state.showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                context
                                    .read<LoginCubit>()
                                    .showPassword(state.showPassword);
                              },
                            ),
                            prefixIcon: Icons.lock,
                          ),
                          Container(
                            alignment: const Alignment(1.0, 0.0),
                            padding:
                                const EdgeInsets.only(top: 10.0, left: 20.0),
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, ForgotPasswordScreen.routeName),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.9,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 26.0,
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                    onPressed: () => _submitForm(context,
                                        state.status == LoginStatus.submitting),
                                    icon: const Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: canvas.height * 0.2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Need an account?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RemoteSignupScreen.routeName);
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
