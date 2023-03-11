import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vault_app/widgets/show_snackbar.dart';

import '/repositories/auth/auth_repository.dart';
import '/screens/home/home_screen.dart';
import '/screens/login/cubit/login_cubit.dart';

class LocalLoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LocalLoginScreen({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const LocalLoginScreen(),
      ),
    );
  }

  @override
  LocalLoginScreenState createState() => LocalLoginScreenState();
}

class LocalLoginScreenState extends State<LocalLoginScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<LoginCubit>().checkPinAvailable();
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submit(LoginCubit loginCubit) {
    formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6 || currentText != '123456') {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    } else {
      setState(
        () {
          hasError = false;
          if (loginCubit.state.pinAvailable) {
            print('This runs 1');
            loginCubit.submitPin();
          } else {
            print('This runs 2');
            loginCubit.setPin();
          }
          //snackBar('OTP Verified!!');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // backgroundColor: Constants.primaryColor,
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.error) {
                errorController?.add(ErrorAnimationType.shake);
                // showDialog(
                //   context: context,
                //   builder: (_) => ErrorDialog(content: state.failure.message),
                // );
              }
              if (state.status == LoginStatus.success) {
                ShowSnackBar.showSnackBar(context, title: 'Pin Verified!!');
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              }
            },
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 70),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset('assets/images/vault-icon.png'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        state.pinAvailable
                            ? 'Enter your pin code'
                            : 'Set You pin code',
                        //'Pin Code Verification',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 30.0, vertical: 8),
                    //   child: Text(
                    //       state.pinAvailable
                    //           ? 'Enter your pin code'
                    //           : 'Set You pin code',
                    //       style: const TextStyle(
                    //           color: Colors.black54, fontSize: 15),
                    //       textAlign: TextAlign.center),
                    // ),

                    // RichText(
                    //   text: TextSpan(
                    //       text: state.pinAvailable
                    //           ? 'Enter your pin code'
                    //           : 'Set You pin code',
                    //       children: [
                    //         TextSpan(
                    //           text: '${widget.phoneNumber}',
                    //           style: const TextStyle(
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 15,
                    //           ),
                    //         ),
                    //       ],

                    //   ),
                    // ),
                    const SizedBox(height: 50),
                    Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: true,
                            obscuringCharacter: '*',

                            //blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v!.length < 3) {
                                return 'Please enter your pin to continue';
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            // enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              debugPrint('Completed');
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              debugPrint(value);
                              setState(() {
                                currentText = value;
                                loginCubit.pinChanged(value);
                              });
                            },
                            beforeTextPaste: (text) {
                              debugPrint('Allowing to paste ');
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? '*Invalid Pin' : '',
                        //'*Please fill up all the cells properly',

                        // '*Please fill up all the cells properly' : '',
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green.shade200,
                                offset: const Offset(1, -2),
                                blurRadius: 5),
                            BoxShadow(
                                color: Colors.green.shade200,
                                offset: const Offset(-1, 2),
                                blurRadius: 5)
                          ]),
                      child: ButtonTheme(
                        height: 50,
                        child: TextButton(
                          onPressed: () => _submit(loginCubit),
                          child: Center(
                              child: Text(
                            'VERIFY'.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: TextButton(
                          child: const Text('Clear'),
                          onPressed: () {
                            textEditingController.clear();
                          },
                        )),
                        // Flexible(
                        //     child: TextButton(
                        //   child: const Text('Set Text'),
                        //   onPressed: () {
                        //     setState(() {
                        //       textEditingController.text = '123456';
                        //     });
                        //   },
                        // )),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
