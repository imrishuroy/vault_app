import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 9)
class Category extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String icon;

  const Category({
    required this.name,
    required this.icon,
  });

  Category copyWith({
    String? name,
    String? icon,
  }) {
    return Category(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'icon': icon});

    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() => 'Category(name: $name, icon: $icon)';

  @override
  List<Object> get props => [name, icon];
}
