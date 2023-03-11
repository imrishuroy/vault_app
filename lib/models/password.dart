import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'password.g.dart';

@HiveType(typeId: 6)
class Password extends Equatable {
  @HiveField(0)
  final String passwordId;
  @HiveField(1)
  final String website;
  @HiveField(2)
  final String password;
  @HiveField(3)
  final DateTime createdAt;

  const Password({
    required this.passwordId,
    required this.website,
    required this.password,
    required this.createdAt,
  });

  Password copyWith({
    String? passwordId,
    String? website,
    String? password,
    DateTime? createdAt,
  }) {
    return Password(
      passwordId: passwordId ?? this.passwordId,
      website: website ?? this.website,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'passwordId': passwordId});
    result.addAll({'website': website});
    result.addAll({'password': password});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      passwordId: map['passwordId'] ?? '',
      website: map['website'] ?? '',
      password: map['password'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(String source) =>
      Password.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Password(passwordId: $passwordId, website: $website, password: $password, createdAt: $createdAt)';
  }

  @override
  List<Object> get props => [passwordId, website, password, createdAt];
}
