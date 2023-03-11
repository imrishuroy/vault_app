import 'package:hive_flutter/hive_flutter.dart';

part 'account_type.g.dart';

@HiveType(typeId: 10)
enum AccountType {
  @HiveField(0)
  savings,
  @HiveField(1)
  current
}
