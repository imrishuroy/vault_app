import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/services/services.dart';

import '/enums/enums.dart';
import '/models/bank_details.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class AddBankArgs {
  final CredentialsCubit credentialsCubit;
  final BankDetails? bankDetails;

  AddBankArgs({
    required this.credentialsCubit,
    this.bankDetails,
  });
}

class AddBankScreen extends StatefulWidget {
  static const routeName = '/add-bank';

  final CredentialsCubit credentialsCubit;
  final BankDetails? bankDetails;

  const AddBankScreen({
    super.key,
    required this.credentialsCubit,
    this.bankDetails,
  });

  static Route route({required AddBankArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider.value(
        value: args.credentialsCubit,
        child: AddBankScreen(
          credentialsCubit: args.credentialsCubit,
          bankDetails: args.bankDetails,
        ),
      ),
    );
  }

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submit(bool isLoading) {
    if (_formKey.currentState!.validate() && !isLoading) {
      print('this bank runs -1 ');

      if (widget.bankDetails != null) {
        widget.credentialsCubit
            .updateBankDetails(bankDetails: widget.bankDetails!);
      } else {
        widget.credentialsCubit.addBankDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final credentialsCubit = context.read<CredentialsCubit>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Bank'),
          actions: [
            if (widget.bankDetails != null)
              IconButton(
                  onPressed: () async {
                    final result = await AskToAction.confirmDelete(
                      context: context,
                      title: 'Delete Bank A/C',
                      message: 'Do you want to delete this A/C ?',
                    );

                    if (result) {
                      if (widget.bankDetails?.bankId != null) {
                        credentialsCubit.deleteBank(widget.bankDetails!.bankId);
                        if (!mounted) return;
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                  icon: const Icon(Icons.delete)),
            const SizedBox(width: 10.0),
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
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == CredentialsStatus.loading) {
              return const LoadingIndicator();
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        CustomTextField(
                          intialValue: widget.bankDetails?.bankName,
                          onChanged: credentialsCubit.bankNameChanged,
                          textInputType: TextInputType.name,
                          labelText: 'Bank Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Bank Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        CustomTextField(
                          intialValue: widget.bankDetails?.accountNumber,
                          onChanged: credentialsCubit.accountNumberChanged,
                          textInputType: TextInputType.number,
                          labelText: 'Account Number',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Account Number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        CustomTextField(
                          intialValue: widget.bankDetails?.ifscCode,
                          onChanged: credentialsCubit.ifscCodeChanged,
                          textInputType: TextInputType.name,
                          labelText: 'IFSC Code',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'IFSC Code is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        CustomTextField(
                          intialValue: widget.bankDetails?.accountHolderName,
                          onChanged: credentialsCubit.accountHolderNameChanged,
                          textInputType: TextInputType.name,
                          labelText: 'Account Holder Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Account Holder Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 10.0),
                            Row(
                              children: [
                                const Text(
                                  'Savings',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Radio<AccountType>(
                                  value: AccountType.savings,
                                  groupValue: state.accountType ??
                                      widget.bankDetails?.accountType,
                                  onChanged:
                                      credentialsCubit.accountTypeChanged,
                                ),
                              ],
                            ),
                            const SizedBox(width: 10.0),
                            Row(
                              children: [
                                const Text(
                                  'Current',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Radio<AccountType>(
                                  value: AccountType.current,
                                  groupValue: state.accountType ??
                                      widget.bankDetails?.accountType,
                                  onChanged:
                                      credentialsCubit.accountTypeChanged,
                                ),
                              ],
                            ),
                            const SizedBox(width: 10.0),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _submit(
                                state.status == CredentialsStatus.loading),
                            child: const Text('Add Bank'),
                          ),
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
  }
}
