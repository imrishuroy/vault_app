// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountTypeAdapter extends TypeAdapter<AccountType> {
  @override
  final int typeId = 10;

  @override
  AccountType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AccountType.savings;
      case 1:
        return AccountType.current;
      default:
        return AccountType.savings;
    }
  }

  @override
  void write(BinaryWriter writer, AccountType obj) {
    switch (obj) {
      case AccountType.savings:
        writer.writeByte(0);
        break;
      case AccountType.current:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
