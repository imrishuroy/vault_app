import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:uuid/uuid.dart';

import '/constants/app_constants.dart';
import '/models/card_details.dart';
import '/screens/credentials/cubit/credentials_cubit.dart';
import '/services/services.dart';
import '/widgets/show_snackbar.dart';

class CreditCardArgs {
  final CredentialsCubit credentialsCubit;
  final CardDetails? cardDetails;

  CreditCardArgs({
    required this.credentialsCubit,
    this.cardDetails,
  });
}

class CreditCardScreen extends StatefulWidget {
  static const String routeName = '/credit-card';

  final CredentialsCubit credentialsCubit;
  final CardDetails? cardDetails;
  const CreditCardScreen({
    Key? key,
    required this.credentialsCubit,
    required this.cardDetails,
  }) : super(key: key);

  static Route route({required CreditCardArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider.value(
        value: args.credentialsCubit,
        child: CreditCardScreen(
          credentialsCubit: args.credentialsCubit,
          cardDetails: args.cardDetails,
        ),
      ),
    );
  }

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      print('valid!');

      final credentialCubit = widget.credentialsCubit;

      final creditCard = CardDetails(
        cardId: widget.cardDetails?.cardId ?? const Uuid().v4(),
        cardHolderName: cardHolderName,
        createdAt: DateTime.now(),
        cvvCode: cvvCode,
        expiryDate: expiryDate,
        cardNumber: cardNumber,
        isCvvFocused: isCvvFocused,
      );

      print('Credit Card detils -- 22 ${creditCard.toString()}');

      if (widget.cardDetails != null) {
        print('update card calllled');
// update card
        credentialCubit.updateCard(cardDetails: creditCard);
      } else {
        // add new card
        credentialCubit.addCreditCard(cardDetails: creditCard);
      }
      Navigator.of(context).pop();
    } else {
      print('invalid!');

      ShowSnackBar.showSnackBar(context, title: 'Form Invalid !');
    }
  }

  void setCreditCardValues() {
    if (widget.cardDetails != null) {
      setState(() {
        cardNumber = widget.cardDetails?.cardNumber ?? '';
        expiryDate = widget.cardDetails?.expiryDate ?? '';
        cardHolderName = widget.cardDetails?.cardHolderName ?? '';
        cvvCode = widget.cardDetails?.cvvCode ?? '';
        isCvvFocused = widget.cardDetails?.isCvvFocused ?? false;
      });
    }
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    setCreditCardValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final credentialCubit = widget.credentialsCubit;
    // setCreditCardValues();

    print('Caredetails -- ${widget.cardDetails?.toString()}');

    print('Card number -- $cardNumber');

    print('Credentials amalal -- ${credentialCubit.state.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
        actions: [
          if (widget.cardDetails != null)
            IconButton(
              onPressed: () async {
                final result = await AskToAction.confirmDelete(
                  context: context,
                  title: 'Delete Card',
                  message: 'Do you want to delete this card',
                );
                if (result) {
                  if (widget.cardDetails?.cardId != null) {
                    credentialCubit.deleteCard(widget.cardDetails!.cardId);
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }
                }
              },
              icon: const Icon(Icons.delete),
            ),
          const SizedBox(width: 10.0),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            CreditCardWidget(
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.white,
              backgroundImage: AppConst.assets.cardBg,
              isSwipeGestureEnabled: true,
              //onCreditCardWidgetChange: onCardBandChanged,
              customCardTypeIcons: <CustomCardTypeIcon>[
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
              onCreditCardWidgetChange: (_) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Colors.blue,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () => _submit()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //  ),
    );
  }
}
