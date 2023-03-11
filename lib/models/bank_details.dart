import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:vault_app/enums/enums.dart';

part 'bank_details.g.dart';

@HiveType(typeId: 7)
class BankDetails extends Equatable {
  @HiveField(0)
  final String bankId;
  @HiveField(1)
  final String accountNumber;
  @HiveField(2)
  final String bankName;
  @HiveField(3)
  final String branchName;
  @HiveField(4)
  final String ifscCode;
  @HiveField(5)
  final AccountType accountType;
  @HiveField(6)
  final String accountHolderName;
  @HiveField(7)
  final DateTime createdAt;

  const BankDetails({
    required this.bankId,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.accountType,
    required this.accountHolderName,
    required this.createdAt,
  });

  BankDetails copyWith({
    String? bankId,
    String? accountNumber,
    String? bankName,
    String? branchName,
    String? ifscCode,
    AccountType? accountType,
    String? accountHolderName,
    DateTime? createdAt,
  }) {
    return BankDetails(
      bankId: bankId ?? this.bankId,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      accountType: accountType ?? this.accountType,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'bankId': bankId});
    result.addAll({'accountNumber': accountNumber});
    result.addAll({'bankName': bankName});
    result.addAll({'branchName': branchName});
    result.addAll({'ifscCode': ifscCode});
    result.addAll({'accountType': EnumToString.convertToString(accountType)});
    result.addAll({'accountHolderName': accountHolderName});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      bankId: map['bankId'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      branchName: map['branchName'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      accountType:
          EnumToString.fromString(AccountType.values, map['accountType']) ??
              AccountType.savings,
      accountHolderName: map['accountHolderName'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BankDetails.fromJson(String source) =>
      BankDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankDetails(bankId: $bankId, accountNumber: $accountNumber, bankName: $bankName, branchName: $branchName, ifscCode: $ifscCode, accountType: $accountType, accountHolderName: $accountHolderName, createdAt: $createdAt)';
  }

  @override
  List<Object> get props {
    return [
      bankId,
      accountNumber,
      bankName,
      branchName,
      ifscCode,
      accountType,
      accountHolderName,
      createdAt,
    ];
  }
}
