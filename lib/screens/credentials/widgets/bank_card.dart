import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/enums/enums.dart';
import '/models/bank_details.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/screens/credentials/screens/add_bank_screen.dart';
import '/services/services.dart';

class BankCard extends StatelessWidget {
  final BankDetails bank;

  const BankCard({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    final credentialsCubit = context.read<CredentialsCubit>();
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).pushNamed(
          AddBankScreen.routeName,
          arguments: AddBankArgs(
            credentialsCubit: credentialsCubit,
            bankDetails: bank,
          ),
        );
        if (result == true) {
          credentialsCubit.loadBankList();
        }
      },
      onLongPress: () async {
        final result = await AskToAction.confirmDelete(
          context: context,
          title: 'Delete Bank A/C',
          message: 'Do you want to delete this A/C ?',
        );

        if (result) {
          credentialsCubit.deleteBank(bank.bankId);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff004e82),
              Color(0xff004e82),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.blueAccent,
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 12.0,
              // spreadRadius: 1.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        height: 120.0,
        //    width: 100.0,
        child: Row(
          children: [
            const SizedBox(width: 30.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  const SizedBox(height: 4.0),
                Icon(
                  Icons.account_balance,
                  size: 40.0,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.2,
                    horizontal: 7.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    bank.accountType == AccountType.savings
                        ? 'Savings'
                        : 'Current',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bank.bankName,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    // color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  bank.accountNumber,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    // color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  bank.ifscCode,
                  style: TextStyle(
                    //  color: Colors.white,
                    color: Colors.grey.shade300,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
