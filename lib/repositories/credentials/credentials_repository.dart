import 'package:hive_flutter/hive_flutter.dart';
import 'package:vault_app/config/hive_config.dart';
import 'package:vault_app/models/bank_details.dart';
import 'package:vault_app/models/card_details.dart';
import 'package:vault_app/models/failure.dart';
import 'package:vault_app/models/password.dart';
import 'package:vault_app/repositories/credentials/base_credentials_repo.dart';

class CredentialsRepository extends BaseCredentialsRepo {
  Future<void> addCreditCard(CardDetails cardDetails) async {
    try {
      await HiveConfig().addCard(cardDetails);
    } on HiveError catch (error) {
      print('Error in adding credit card ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding credit card ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> deleteCard(String cardId) async {
    try {
      await HiveConfig().deleteCard(cardId);
    } on HiveError catch (error) {
      print('Error in deleting credit card ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting credit card ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  List<CardDetails> getAllCreditCards() {
    try {
      return HiveConfig().getAllCards();
    } on HiveError catch (error) {
      print('Error in getting credit cards ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting credit cards ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> addBankDetails(BankDetails bankDetails) async {
    try {
      print('this bank runs  - 3 ${bankDetails.toString()}');
      await HiveConfig().addBankDetails(bankDetails);
    } on HiveError catch (error) {
      print('Error in adding bank details ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding bank details ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> updateCreditCard(CardDetails cardDetails) async {
    try {
      print('Repo update credit card -- ${cardDetails.toString()}');
      await HiveConfig().updateCard(cardDetails);
    } on HiveError catch (error) {
      print('Error in updating credit card ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating credit card ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> deleteBank(String bankId) async {
    try {
      await HiveConfig().deleteBankDetails(bankId);
    } on HiveError catch (error) {
      print('Error in deleting bank details ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting bank details ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  List<BankDetails> getAllBankDetails() {
    try {
      return HiveConfig().getAllBankDetails();
    } on HiveError catch (error) {
      print('Error in getting bank details ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting bank details ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> updateBankDetails(BankDetails bankDetails) async {
    try {
      await HiveConfig().updateBankDetails(bankDetails);
    } on HiveError catch (error) {
      print('Error in updating bank details ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating bank details ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> createPassword(Password password) async {
    try {
      await HiveConfig().addPassword(password);
    } on HiveError catch (error) {
      print('Error in adding password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> updatePassword(Password password) async {
    try {
      await HiveConfig().updatePassword(password);
    } on HiveError catch (error) {
      print('Error in updating password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> deletePassword(String passwordId) async {
    try {
      await HiveConfig().deletePassword(passwordId);
    } on HiveError catch (error) {
      print('Error in deleting password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  List<Password> getAllPasswords() {
    try {
      return HiveConfig().getAllPasswords();
    } on HiveError catch (error) {
      print('Error in getting passwords ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting passwords ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> addPassword(Password password) async {
    try {
      print('this password runs -3 ${password.toString()}');
      await HiveConfig().addPassword(password);
    } on HiveError catch (error) {
      print('Error in adding password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
