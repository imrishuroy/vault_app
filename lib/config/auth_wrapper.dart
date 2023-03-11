import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/screens/home/home_screen.dart';

import '/blocs/auth/auth_bloc.dart';

class AuthWrapper extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthWrapper({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AuthWrapper(),
    );
  }

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    /// context.read<AuthBloc>().add(LoggedIn());
    context.read<AuthBloc>().add(CheckLocalAuthAvailable());
    // authBloc.add(CheckLocalAuthAvailable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          print('Auth State $state');

          print('Auth State $state');

          if (state is LocalAuthAvailable) {
            authBloc.add(AuthenticateWithLocalAuth());
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          } else if (state is AuthenticationUnauthenticated) {
            //  Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state is AuthLocalAuthenticated) {
            //  Navigator.of(context).pushNamed(NavScreen.routeName);
          } else if (state is LocalAuthError) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Authentication Error'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Try Again'),
                    onPressed: () {
                      authBloc.add(AuthenticateWithLocalAuth());
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          }

          // //Navigator.of(context).pushNamed(LoginScreen.routeName);
          // if (state is AuthenticationAuthenticated) {
          //   // Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
          //   //authBloc.add(CheckLocalAuthAvailable());

          //   // if (state is LocalAuthAvailable) {
          //   // } else {
          //   //   // Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          //   // }

          //   //   Navigator.of(context).pushNamed(HomeScreen.routeName);
          //   // Navigator.of(context).pushNamed(NavScreen.routeName);
          // } else
        },
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
