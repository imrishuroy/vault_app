import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/screens/backup/cubit/backup_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class BackupData extends StatelessWidget {
  const BackupData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backupCubit = context.read<BackUpCubit>();
    final authBloc = context.read<AuthBloc>();
    final authenticatedUser = authBloc.state as RemoteUserAuthenticated;
    print('User id ${authenticatedUser.user?.uid}');
    return BlocConsumer<BackUpCubit, BackUpState>(
      listener: (context, state) {
        if (state.status == BackUpStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        print('Status of backup data ${state.status}');
        if (state.status == BackUpStatus.submitting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LoadingIndicator(),
              SizedBox(height: 15.0),
              Text(
                'Please wait we are uploading your data\n This may take a while',
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (authenticatedUser.user?.uid != null) {
                    backupCubit.downloadData(
                        userId: authenticatedUser.user!.uid!);
                  }
                },
                child: const CircleAvatar(
                  radius: 32.0,
                  child: Icon(
                    Icons.cloud_download,
                    size: 32.0,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text('Tap on the icon to download your data'),
              const SizedBox(height: 40.0),
              const SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  if (authenticatedUser.user?.uid != null) {
                    backupCubit.backupData(
                        userId: authenticatedUser.user!.uid!);
                  }
                },
                child: const CircleAvatar(
                  radius: 32.0,
                  child: Icon(
                    Icons.cloud_upload,
                    size: 32.0,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text('Tap on the icon to backup your data'),
            ],
          ),
        );
      },
    );
  }
}
