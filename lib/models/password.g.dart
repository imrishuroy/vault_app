// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordAdapter extends TypeAdapter<Password> {
  @override
  final int typeId = 6;

  @override
  Password read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Password(
      passwordId: fields[0] as String,
      website: fields[1] as String,
      password: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Password obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.passwordId)
      ..writeByte(1)
      ..write(obj.website)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
