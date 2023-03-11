import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/credentials/cubit/credentials_cubit.dart';
import '/screens/credentials/widgets/bank_card.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  @override
  void initState() {
    context.read<CredentialsCubit>().loadBankList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.bankDetailsList.length,
                    itemBuilder: (context, index) {
                      final bank = state.bankDetailsList[index];
                      return BankCard(bank: bank);
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
