import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '/constants/app_constants.dart';
import '/screens/credentials/credit_card_screen.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/services/services.dart';
import '/widgets/loading_indicator.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    context.read<CredentialsCubit>().loadCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final credentialCubit = context.read<CredentialsCubit>();
    return BlocConsumer<CredentialsCubit, CredentialsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == CredentialsStatus.loading) {
          return const LoadingIndicator();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.cardDetailsList.length,
                itemBuilder: (context, index) {
                  final creditCard = state.cardDetailsList[index];
                  return GestureDetector(
                    onLongPress: () async {
                      final result = await AskToAction.confirmDelete(
                        context: context,
                        title: 'Delete Card',
                        message: 'Do you want to delete this card',
                      );
                      if (result) {
                        if (creditCard?.cardId != null) {
                          credentialCubit.deleteCard(creditCard!.cardId);
                        }
                      }
                    },
                    onTap: () => Navigator.of(context).pushNamed(
                      CreditCardScreen.routeName,
                      arguments: CreditCardArgs(
                        credentialsCubit: credentialCubit,
                        cardDetails: creditCard,
                      ),
                    ),
                    child: CreditCardWidget(
                      cardHolderName: creditCard?.cardHolderName ?? '',
                      cvvCode: creditCard?.cvvCode ?? '',
                      expiryDate: creditCard?.expiryDate ?? '',
                      cardNumber: creditCard?.cardNumber ?? '',
                      cardBgColor: Colors.white,
                      obscureCardNumber: false,
                      obscureCardCvv: false,
                      customCardTypeIcons: [
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            AppConst.assets.mastercard,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        CustomCardTypeIcon(
                          cardType: CardType.discover,
                          cardImage: Image.asset(
                            AppConst.assets.discover,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        CustomCardTypeIcon(
                          cardType: CardType.visa,
                          cardImage: Image.asset(
                            AppConst.assets.visa,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        CustomCardTypeIcon(
                          cardType: CardType.americanExpress,
                          cardImage: Image.asset(
                            AppConst.assets.amex,
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                      backgroundImage: AppConst.assets.cardBg,
                      showBackView: false,
                      onCreditCardWidgetChange: (_) {},
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
