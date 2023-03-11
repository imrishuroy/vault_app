import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/repositories/backup/backup_repository.dart';
import '/screens/backup/backup_data.dart';
import '/screens/backup/cubit/backup_cubit.dart';
import '/screens/login/remote_login_screen.dart';

class BackupScreen extends StatelessWidget {
  static const routeName = '/backup';
  const BackupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const BackupScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup Your Data'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is RemoteUserAuthenticated) {
            return BlocProvider<BackUpCubit>(
              create: (context) => BackUpCubit(
                backUpRepository: context.read<BackUpRepository>(),
              ),
              child: const BackupData(),
            );
          } else {
            return Center(
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () => Navigator.of(context)
                    .pushNamed(RemoteLoginScreen.routeName),
              ),
            );
          }
        },
      ),
    );
  }
}
