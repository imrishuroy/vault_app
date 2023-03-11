import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:uuid/uuid.dart';

import '/enums/enums.dart';
import '/models/bank_details.dart';
import '/models/card_details.dart';
import '/models/failure.dart';
import '/models/password.dart';
import '/repositories/credentials/credentials_repository.dart';

part 'credentials_state.dart';

class CredentialsCubit extends Cubit<CredentialsState> {
  final CredentialsRepository _credentialsRepository;
  CredentialsCubit({required CredentialsRepository credentialsRepository})
      : _credentialsRepository = credentialsRepository,
        super(CredentialsState.initial());

  void loadCredentials() {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      final creditCards = _credentialsRepository.getAllCreditCards();
      final bankDetailsList = _credentialsRepository.getAllBankDetails();
      final passwordList = _credentialsRepository.getAllPasswords();
      print('Credit cards: $creditCards');

      emit(
        state.copyWith(
          cardDetailsList: creditCards,
          bankDetailsList: bankDetailsList,
          passwordList: passwordList,
          status: CredentialsStatus.loaded,
        ),
      );

      // final bankDetailsList = _credentialsRepository.getAllBankDetails();
      // final passwordList = _credentialsRepository.getAllPasswords();
      // emit(state.copyWith(
      //     creditCards: creditCards,
      //     bankDetailsList: bankDetailsList,
      //     passwordList: passwordList,
      //     status: CredentialsStatus.loaded));
    } on Failure catch (failure) {
      emit(state.copyWith(status: CredentialsStatus.error, failure: failure));
    }
  }

  void loadBankList() {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      final bankDetailsList = _credentialsRepository.getAllBankDetails();

      emit(state.copyWith(
        bankDetailsList: bankDetailsList,
        status: CredentialsStatus.loaded,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  void addCreditCard({required CardDetails? cardDetails}) {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      print('Card Details -- ${cardDetails.toString()}');

      if (cardDetails != null) {
        _credentialsRepository.addCreditCard(cardDetails);

        loadCredentials();

        // emit(state.copyWith(status: CredentialsStatus.success));
      } else {
        emit(state.copyWith(status: CredentialsStatus.initial));
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  void updateCard({required CardDetails cardDetails}) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      await _credentialsRepository.updateCreditCard(cardDetails);
      print('Credit cards update: $cardDetails');

      emit(
        state.copyWith(
          cardDetailsList: state.cardDetailsList.map((card) {
            if (card?.cardId == cardDetails.cardId) {
              return cardDetails;
            }
            return card;
          }).toList(),
          status: CredentialsStatus.loaded,
        ),
      );

      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(status: CredentialsStatus.error, failure: failure));
    }
  }

  void deleteCard(String cardId) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      await _credentialsRepository.deleteCard(cardId);
      print('Credit cards deleted');

      emit(
        state.copyWith(
          cardDetailsList:
              state.cardDetailsList.where((card) => cardId != cardId).toList(),
          status: CredentialsStatus.loaded,
        ),
      );
      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(status: CredentialsStatus.error, failure: failure));
    }
  }
  // bank

  void bankNameChanged(String value) {
    emit(
      state.copyWith(bankName: value, status: CredentialsStatus.initial),
    );
  }

  void accountNumberChanged(String value) {
    emit(
      state.copyWith(accountNumber: value, status: CredentialsStatus.initial),
    );
  }

  void ifscCodeChanged(String value) {
    emit(
      state.copyWith(ifscCode: value, status: CredentialsStatus.initial),
    );
  }

  void accountHolderNameChanged(String value) {
    emit(
      state.copyWith(
          accountHolderName: value, status: CredentialsStatus.initial),
    );
  }

  void accountTypeChanged(AccountType? accountType) {
    emit(
      state.copyWith(
          accountType: accountType, status: CredentialsStatus.initial),
    );
  }

  void addBankDetails() async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      if (state.bankFormValid) {
        print('this bank runs -2 ');
        final bankDetails = BankDetails(
          bankId: const Uuid().v4(),
          bankName: state.bankName!,
          accountNumber: state.accountNumber!,
          ifscCode: state.ifscCode!,
          accountHolderName: state.accountHolderName!,
          accountType: state.accountType!,
          createdAt: DateTime.now(),
          branchName: '',
        );
        await _credentialsRepository.addBankDetails(bankDetails);
        emit(state.copyWith(status: CredentialsStatus.success));
        loadCredentials();
      } else {
        emit(state.copyWith(status: CredentialsStatus.initial));
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  void deleteBank(String bankId) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      await _credentialsRepository.deleteBank(bankId);
      print('Credit cards deleted');

      // emit(
      //   state.copyWith(
      //     bankDetailsList:
      //         state.bankDetailsList.where((bank) => bankId != bankId).toList(),
      //     //status: CredentialsStatus.loaded,
      //   ),
      // );

      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(status: CredentialsStatus.error, failure: failure));
    }
  }

  void updateBankDetails({required BankDetails bankDetails}) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      print('this bank runs -2 ');

      await _credentialsRepository.updateBankDetails(
        bankDetails.copyWith(
          createdAt: DateTime.now(),
          bankName: state.bankName ?? bankDetails.bankName,
          accountNumber: state.accountNumber ?? bankDetails.accountNumber,
          ifscCode: state.ifscCode ?? bankDetails.ifscCode,
          accountHolderName:
              state.accountHolderName ?? bankDetails.accountHolderName,
          accountType: state.accountType ?? bankDetails.accountType,
          branchName: '',
        ),
      );

      // print('Updated baking details: $bankDetails');
      // emit(state.copyWith(
      //   status: CredentialsStatus.success,
      //   bankDetailsList: state.bankDetailsList.map((bank) {
      //     if (bank.bankId == bankDetails.bankId) {
      //       return bankDetails;
      //     }
      //     return bank;
      //   }).toList(),
      // ));

      emit(state.copyWith(status: CredentialsStatus.success));

      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  // password

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: CredentialsStatus.initial,
      ),
    );
  }

  void websiteChanged(String value) {
    emit(
      state.copyWith(
        website: value,
        status: CredentialsStatus.initial,
      ),
    );
  }

  void addPassword() async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      if (state.passwordFormValid) {
        print('this password runs -2 ');
        final password = Password(
          passwordId: const Uuid().v4(),
          password: state.password!,
          website: state.website!,
          createdAt: DateTime.now(),
        );
        await _credentialsRepository.addPassword(password);
        emit(state.copyWith(status: CredentialsStatus.success));
        // emit(state.copyWith(status: CredentialsStatus.success));
        loadCredentials();
      } else {
        emit(state.copyWith(status: CredentialsStatus.initial));
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  void deletePassword(String passwordId) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      await _credentialsRepository.deletePassword(passwordId);
      print('Credit cards deleted');

      // emit(
      //   state.copyWith(
      //     passwordList: state.passwordList
      //         .where((password) => password.passwordId != passwordId)
      //         .toList(),
      //     status: CredentialsStatus.loaded,
      //   ),
      // );
      emit(state.copyWith(status: CredentialsStatus.success));

      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(status: CredentialsStatus.error, failure: failure));
    }
  }

  void loadPassword() {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      final passwords = _credentialsRepository.getAllPasswords();

      emit(state.copyWith(
          passwordList: passwords, status: CredentialsStatus.loaded));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }

  void updatePassword({required Password password}) async {
    try {
      emit(state.copyWith(status: CredentialsStatus.loading));

      print('this password runs -2 ');

      await _credentialsRepository.updatePassword(
        password.copyWith(
          createdAt: DateTime.now(),
          password: state.password ?? password.password,
          website: state.website ?? password.website,
        ),
      );

      print('Updated baking details: $password');
      // emit(state.copyWith(
      //   status: CredentialsStatus.success,
      //   passwordList: state.passwordList.map((password) {
      //     if (password.passwordId == password.passwordId) {
      //       return password;
      //     }
      //     return password;
      //   }).toList(),
      // ));
      emit(state.copyWith(status: CredentialsStatus.success));
      loadCredentials();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: CredentialsStatus.error));
    }
  }
}
