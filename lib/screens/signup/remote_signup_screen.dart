import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vault_app/screens/backup/backup_screen.dart';

import '/repositories/auth/auth_repository.dart';
import '/screens/signup/cubit/signup_cubit.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class RemoteSignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  RemoteSignupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: RemoteSignupScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _launchInBrowser(String url) async {
    final bool canLaunch = await canLaunchUrl(Uri.parse(url));

    if (!canLaunch) {
      throw 'Could not launch $url';
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }

  // Future<void> _pickImage(BuildContext context) async {
  //   final pickedImage = await ImageUtil.pickImageFromGallery(
  //     cropStyle: CropStyle.circle,
  //     context: context,
  //     imageQuality: 30,
  //     title: 'Pick profile pic',
  //   );

  //   context.read<SignupCubit>().imagePicked(await pickedImage?.readAsBytes());
  // }

  @override
  Widget build(BuildContext context) {
    final canvas = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            print('Current state ${state.status}');
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
            if (state.status == SignupStatus.success) {
              Navigator.popUntil(
                  context, ModalRoute.withName(BackupScreen.routeName));
            }
          },
          builder: (context, state) {
            return Scaffold(
              // backgroundColor: Colors.transparent,
              body: state.status == SignupStatus.submitting
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
                                'SignUp To BackUp Your Data',
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
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .emailChanged(value),
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
                                    .read<SignupCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value!.length < 6
                                    ? 'Password too short'
                                    : null,
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
                                        .read<SignupCubit>()
                                        .showPassword(state.showPassword);
                                  },
                                ),
                                prefixIcon: Icons.lock,
                              ),
                              const SizedBox(height: 10.0),
                              Text.rich(
                                TextSpan(
                                  // text: 'By clicking the ',
                                  children: <InlineSpan>[
                                    const TextSpan(text: ' By clicking the '),
                                    const TextSpan(
                                      text: 'Register',
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                    const TextSpan(
                                        text: ' button you agree to the '),
                                    TextSpan(
                                      text: 'T&C ',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchInBrowser('termsOfService'),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: '\nOur '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchInBrowser('privacyPolicy'),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13.0,
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign Up',
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
                                        onPressed: () => _submitForm(
                                          context,
                                          state.status ==
                                              SignupStatus.submitting,
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_forward_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );

    //         return state.status == SignupStatus.submitting
    //             ? const LoadingIndicator()
    //             : Form(
    //                 key: _formKey,
    //                 child: ListView(
    //                   children: <Widget>[
    //                     const SizedBox(height: 30.0),
    //                     Image.asset(
    //                       'assets/images/vault-icon.png',
    //                       height: 80.0,
    //                       width: 80.0,
    //                     ),
    //                     const SizedBox(height: 30.0),
    //                     const Text(
    //                       'Secrect Vault',
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 24.0,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                     const SizedBox(height: 5.0),
    //                     Padding(
    //                       padding: const EdgeInsets.only(
    //                           top: 22.0, left: 20.0, right: 20.0),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.stretch,
    //                         children: [
    //                           CustomTextField(
    //                             textInputType: TextInputType.emailAddress,
    //                             onChanged: (value) => context
    //                                 .read<SignupCubit>()
    //                                 .emailChanged(value),
    //                             validator: (value) =>
    //                                 !(value!.contains('@gmail.com'))
    //                                     ? 'Invalid Email'
    //                                     : null,
    //                             prefixIcon: Icons.mail,
    //                             labelText: 'Email',
    //                           ),
    //                           const SizedBox(height: 20.0),
    //                           CustomTextField(
    //                             maxLines: 1,
    //                             textInputType: TextInputType.visiblePassword,
    //                             isPassowrdField: !state.showPassword,
    //                             onChanged: (value) => context
    //                                 .read<SignupCubit>()
    //                                 .passwordChanged(value),
    //                             validator: (value) => value!.length < 6
    //                                 ? 'Password too short'
    //                                 : null,
    //                             suffixIcon: IconButton(
    //                               color: Colors.white,
    //                               icon: Icon(
    //                                 state.showPassword
    //                                     ? Icons.visibility_off
    //                                     : Icons.visibility,
    //                               ),
    //                               onPressed: () {
    //                                 context
    //                                     .read<SignupCubit>()
    //                                     .showPassword(state.showPassword);
    //                               },
    //                             ),
    //                             prefixIcon: Icons.lock,
    //                             labelText: 'Password',
    //                           ),
    //                           Text.rich(
    //                             TextSpan(
    //                               // text: 'By clicking the ',
    //                               children: <InlineSpan>[
    //                                 const TextSpan(text: ' By clicking the '),
    //                                 const TextSpan(
    //                                   text: 'Register',
    //                                   style: TextStyle(color: Colors.pink),
    //                                 ),
    //                                 const TextSpan(
    //                                     text: ' button you agree to the '),
    //                                 TextSpan(
    //                                   text: 'T&C ',
    //                                   recognizer: TapGestureRecognizer()
    //                                     ..onTap = () =>
    //                                         _launchInBrowser('termsOfService'),
    //                                   style: const TextStyle(
    //                                     color: Colors.blue,
    //                                     fontWeight: FontWeight.w600,
    //                                   ),
    //                                 ),
    //                                 const TextSpan(text: '\n\nOur '),
    //                                 TextSpan(
    //                                   text: 'Privacy Policy',
    //                                   recognizer: TapGestureRecognizer()
    //                                     ..onTap = () =>
    //                                         _launchInBrowser('privacyPolicy'),
    //                                   style: const TextStyle(
    //                                     color: Colors.blue,
    //                                     fontWeight: FontWeight.w600,
    //                                   ),
    //                                 )
    //                               ],
    //                             ),
    //                             style: TextStyle(
    //                               color: Colors.grey.shade600,
    //                               fontSize: 13.0,
    //                             ),
    //                           ),
    //                           const SizedBox(height: 20.0),
    //                           Padding(
    //                             padding:
    //                                 const EdgeInsets.symmetric(horizontal: 5.0),
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 const Text(
    //                                   'Sign Up',
    //                                   style: TextStyle(
    //                                     color: Colors.black,
    //                                     fontSize: 18.0,
    //                                     fontWeight: FontWeight.w600,
    //                                   ),
    //                                 ),
    //                                 CircleAvatar(
    //                                   radius: 26.0,
    //                                   backgroundColor: Colors.black,
    //                                   child: IconButton(
    //                                     onPressed: () => _submitForm(
    //                                       context,
    //                                       state.status ==
    //                                           SignupStatus.submitting,
    //                                     ),
    //                                     icon: const Icon(
    //                                       Icons.arrow_forward_outlined,
    //                                       color: Colors.white,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     const SizedBox(height: 35.0),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         const Text(
    //                           'Already have an account?',
    //                           style: TextStyle(
    //                             color: Colors.black,
    //                             fontSize: 15.0,
    //                           ),
    //                         ),
    //                         const SizedBox(width: 5.0),
    //                         GestureDetector(
    //                           onTap: () => Navigator.of(context).pop(),
    //                           child: const Text(
    //                             'Sign In',
    //                             style: TextStyle(
    //                               color: Colors.blue,
    //                               fontSize: 16.0,
    //                               letterSpacing: 1.0,
    //                               fontWeight: FontWeight.w600,
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                     const SizedBox(height: 14.0),
    //                   ],
    //                 ),
    //               );
    //       },
    //     ),
    //   ),
    // );
  }
}

//  Container(
//   height: 200.0,
//   width: 200.0,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(100.0),
//     gradient: LinearGradient(
//       begin: Alignment.center,
//       end: Alignment.bottomLeft,
//       stops: [
//         //    0.06, 0.5, 0.9, 2.0

//         0.8, 0.6, 0.8,
//       ],
//       colors: [
//         Colors.white10,
//         Colors.white54,
//         Colors.white54,
//       ],
//     ),
//   ),
// )

// CircleAvatar(
//   backgroundColor: Colors.white10.withOpacity(0.05),
//   radius: 100.0,
// ),


