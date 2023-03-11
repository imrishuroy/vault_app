import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/services/ask_to_action_service.dart';
import 'package:vault_app/widgets/custom_textfield.dart';

import '/models/password.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class AddPasswordArgs {
  final CredentialsCubit credentialsCubit;
  final Password? password;

  const AddPasswordArgs({
    required this.credentialsCubit,
    this.password,
  });
}

class AddPasswordScreen extends StatefulWidget {
  static const routeName = '/add-password';

  final CredentialsCubit credentialsCubit;
  final Password? password;

  const AddPasswordScreen({
    super.key,
    required this.credentialsCubit,
    this.password,
  });

  static Route route({required AddPasswordArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider.value(
        value: args.credentialsCubit,
        child: AddPasswordScreen(
          credentialsCubit: args.credentialsCubit,
          password: args.password,
        ),
      ),
    );
  }

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _fromKey = GlobalKey<FormState>();

  void _submit(bool isSubmitting) {
    if (_fromKey.currentState!.validate() && !isSubmitting) {
      print('this password runs -1 ');

      if (widget.password != null) {
        widget.credentialsCubit.updatePassword(password: widget.password!);
      } else {
        widget.credentialsCubit.addPassword();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final credentialsCubit = context.read<CredentialsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await AskToAction.confirmDelete(
                context: context,
                title: 'Delete Password',
                message: 'Do you want to delete this password ?',
              );

              if (result) {
                if (widget.password?.passwordId != null) {
                  credentialsCubit.deletePassword(widget.password!.passwordId);
                  if (!mounted) return;
                  Navigator.of(context).pop(true);
                }
              }
            },
          ),
          const SizedBox(height: 10.0),
        ],
      ),
      body: BlocConsumer<CredentialsCubit, CredentialsState>(
        listener: (context, state) {
          if (state.status == CredentialsStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
          if (state.status == CredentialsStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          if (state.status == CredentialsStatus.loading) {
            return const LoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _fromKey,
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    intialValue: widget.password?.website,
                    onChanged: credentialsCubit.websiteChanged,
                    textInputType: TextInputType.name,
                    labelText: 'Website',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Website is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    intialValue: widget.password?.password,
                    onChanged: credentialsCubit.passwordChanged,
                    textInputType: TextInputType.visiblePassword,
                    labelText: 'Password',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () =>
                        _submit(state.status == CredentialsStatus.loading),
                    child: const Text('Submit'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
