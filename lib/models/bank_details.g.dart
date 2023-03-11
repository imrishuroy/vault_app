// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankDetailsAdapter extends TypeAdapter<BankDetails> {
  @override
  final int typeId = 7;

  @override
  BankDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankDetails(
      bankId: fields[0] as String,
      accountNumber: fields[1] as String,
      bankName: fields[2] as String,
      branchName: fields[3] as String,
      ifscCode: fields[4] as String,
      accountType: fields[5] as AccountType,
      accountHolderName: fields[6] as String,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BankDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bankId)
      ..writeByte(1)
      ..write(obj.accountNumber)
      ..writeByte(2)
      ..write(obj.bankName)
      ..writeByte(3)
      ..write(obj.branchName)
      ..writeByte(4)
      ..write(obj.ifscCode)
      ..writeByte(5)
      ..write(obj.accountType)
      ..writeByte(6)
      ..write(obj.accountHolderName)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
