import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/credentials/cubit/credentials_cubit.dart';
import '/screens/credentials/screens/add_password_screen.dart';
import '/services/services.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snackbar.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  void initState() {
    context.read<CredentialsCubit>().loadPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final credentialsCubit = context.read<CredentialsCubit>();
    return Scaffold(
        body: BlocConsumer<CredentialsCubit, CredentialsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == CredentialsStatus.loading) {
          return const LoadingIndicator();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.passwordList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final password = state.passwordList[index];
                    return ListTile(
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                          AddPasswordScreen.routeName,
                          arguments: AddPasswordArgs(
                            credentialsCubit: credentialsCubit,
                            password: password,
                          ),
                        );

                        if (result == true) {
                          credentialsCubit.loadPassword();
                        }
                      },
                      onLongPress: () async {
                        final result = await AskToAction.confirmDelete(
                          context: context,
                          title: 'Delete Password',
                          message: 'Do you want to delete this password ?',
                        );

                        if (result) {
                          credentialsCubit.deletePassword(password.passwordId);
                        }
                      },
                      title: Text(password.website),
                      subtitle: Text(password.password),
                      trailing: IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: password.password));
                          ShowSnackBar.showSnackBar(context,
                              title: 'Copied to clipboard');
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
