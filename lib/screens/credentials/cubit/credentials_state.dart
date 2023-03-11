part of 'credentials_cubit.dart';

enum CredentialsStatus { initial, loading, success, loaded, error }

class CredentialsState extends Equatable {
  final List<CreditCardModel> creditCards;
  final CreditCardModel? creditCardModel;
  final CardDetails? cardDetails;

  final List<CardDetails?> cardDetailsList;

  final BankDetails? bankDetails;
  final List<BankDetails> bankDetailsList;
  final List<Password> passwordList;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? website;
  final String? password;
  final String? accountHolderName;
  final AccountType? accountType;
  final Failure failure;
  final CredentialsStatus status;

  const CredentialsState({
    this.cardDetails,
    required this.creditCards,
    this.creditCardModel,
    this.bankDetails,
    required this.bankDetailsList,
    this.password,
    required this.cardDetailsList,
    required this.passwordList,
    required this.failure,
    required this.status,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.accountType,
    this.website,
  });

  factory CredentialsState.initial() => const CredentialsState(
        creditCards: [],
        bankDetailsList: [],
        passwordList: [],
        failure: Failure(),
        cardDetailsList: [],
        status: CredentialsStatus.initial,
      );

  bool get bankFormValid =>
      bankName != null &&
      accountNumber != null &&
      ifscCode != null &&
      accountHolderName != null &&
      accountType != null;

  bool get passwordFormValid => password != null && website != null;

  @override
  List<Object?> get props {
    return [
      cardDetails,
      creditCards,
      creditCardModel,
      bankDetails,
      bankDetailsList,
      password,
      passwordList,
      cardDetailsList,
      failure,
      status,
      bankName,
      accountNumber,
      ifscCode,
      accountHolderName,
      accountType,
      website,
      password,
    ];
  }

  CredentialsState copyWith({
    List<CreditCardModel>? creditCards,
    CreditCardModel? creditCardModel,
    BankDetails? bankDetails,
    List<BankDetails>? bankDetailsList,
    // Password? password,
    List<Password>? passwordList,
    Failure? failure,
    CredentialsStatus? status,
    CardDetails? cardDetails,
    List<CardDetails?>? cardDetailsList,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? accountHolderName,
    AccountType? accountType,
    String? website,
    String? password,
  }) {
    return CredentialsState(
      creditCards: creditCards ?? this.creditCards,
      creditCardModel: creditCardModel ?? this.creditCardModel,
      bankDetails: bankDetails ?? this.bankDetails,
      bankDetailsList: bankDetailsList ?? this.bankDetailsList,
      password: password ?? this.password,
      passwordList: passwordList ?? this.passwordList,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      cardDetails: cardDetails ?? this.cardDetails,
      cardDetailsList: cardDetailsList ?? this.cardDetailsList,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountType: accountType ?? this.accountType,
      website: website ?? this.website,
    );
  }

  @override
  String toString() {
    return 'CredentialsState(creditCards: $creditCards, creditCardModel: $creditCardModel, cardDetails: $cardDetails, cardDetailsList: $cardDetailsList, bankDetails: $bankDetails, bankDetailsList: $bankDetailsList, passwordList: $passwordList, bankName: $bankName, accountNumber: $accountNumber, ifscCode: $ifscCode, website: $website, password: $password, accountHolderName: $accountHolderName, accountType: $accountType, failure: $failure, status: $status)';
  }
}
