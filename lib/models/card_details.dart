import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'card_details.g.dart';

@HiveType(typeId: 8)
class CardDetails extends Equatable {
  @HiveField(0)
  final String cardId;
  @HiveField(1)
  final String cardNumber;
  @HiveField(2)
  final String expiryDate;
  @HiveField(3)
  final String cardHolderName;
  @HiveField(4)
  final String cvvCode;
  @HiveField(5)
  final bool isCvvFocused;
  @HiveField(6)
  final DateTime createdAt;

  const CardDetails({
    required this.cardId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.isCvvFocused,
    required this.createdAt,
  });

  CardDetails copyWith({
    String? cardId,
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    bool? isCvvFocused,
    DateTime? createdAt,
  }) {
    return CardDetails(
      cardId: cardId ?? this.cardId,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      isCvvFocused: isCvvFocused ?? this.isCvvFocused,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'cardId': cardId});
    result.addAll({'cardNumber': cardNumber});
    result.addAll({'expiryDate': expiryDate});
    result.addAll({'cardHolderName': cardHolderName});
    result.addAll({'cvvCode': cvvCode});
    result.addAll({'isCvvFocused': isCvvFocused});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory CardDetails.fromMap(Map<String, dynamic> map) {
    return CardDetails(
      cardId: map['cardId'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      cvvCode: map['cvvCode'] ?? '',
      isCvvFocused: map['isCvvFocused'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CardDetails.fromJson(String source) =>
      CardDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CardDetails(cardId: $cardId, cardNumber: $cardNumber, expiryDate: $expiryDate, cardHolderName: $cardHolderName, cvvCode: $cvvCode, isCvvFocused: $isCvvFocused, createdAt: $createdAt)';
  }

  @override
  List<Object> get props {
    return [
      cardId,
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      isCvvFocused,
      createdAt,
    ];
  }
}
