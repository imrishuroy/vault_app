import 'dart:convert';

import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? email;
  final String? name;
  final String? uid;
  final String? profilePic;
  final DateTime? createdAt;

  const AppUser({
    this.email,
    this.name,
    this.uid,
    this.profilePic,
    this.createdAt,
  });

  AppUser copyWith({
    String? email,
    String? name,
    String? uid,
    String? profilePic,
    DateTime? createdAt,
  }) {
    return AppUser(
      email: email ?? this.email,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (email != null) {
      result.addAll({'email': email});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (uid != null) {
      result.addAll({'uid': uid});
    }
    if (profilePic != null) {
      result.addAll({'profilePic': profilePic});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'],
      name: map['name'],
      uid: map['uid'],
      profilePic: map['profilePic'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(email: $email, name: $name, uid: $uid, profilePic: $profilePic, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      email,
      name,
      uid,
      profilePic,
      createdAt,
    ];
  }
}
