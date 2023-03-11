import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/repositories/credentials/credentials_repository.dart';
import '/screens/credentials/credit_card_screen.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/screens/credentials/screens/add_password_screen.dart';
import '/screens/credentials/screens/bank_screen.dart';
import 'screens/add_bank_screen.dart';
import 'screens/password_screen.dart';
import 'widgets/cards_screen.dart';

// credit / debit card
// passwords
// bank accounts

class CredentialsScreen extends StatefulWidget {
  static const String routeName = '/credentials';
  const CredentialsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => CredentialsCubit(
          credentialsRepository: context.read<CredentialsRepository>(),
        ),
        child: const CredentialsScreen(),
      ),
    );
  }

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    final credentialCubit = context.read<CredentialsCubit>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            if (_tabController.index == 0) {
              // go to add credit card screen
              Navigator.of(context).pushNamed(
                CreditCardScreen.routeName,
                arguments: CreditCardArgs(
                  credentialsCubit: credentialCubit,
                ),
              );
            } else if (_tabController.index == 1) {
              // go to add bank screen
              Navigator.of(context).pushNamed(
                AddBankScreen.routeName,
                arguments: AddBankArgs(
                  credentialsCubit: credentialCubit,
                ),
              );
            } else {
              Navigator.of(context).pushNamed(
                AddPasswordScreen.routeName,
                arguments: AddPasswordArgs(
                  credentialsCubit: credentialCubit,
                ),
              );
            }
          },
        ),
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.credit_card),
                text: 'Cards',
              ),
              Tab(
                icon: Icon(Icons.account_balance),
                text: 'Bank A/C',
              ),
              Tab(
                icon: Icon(Icons.key),
                text: 'Passwords',
              ),
            ],
          ),
          title: const Text('Credentials'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            CardsScreen(),
            BankScreen(),
            PasswordScreen(),
          ],
        ),
      ),
    );
  }
}
