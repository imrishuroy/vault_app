// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardDetailsAdapter extends TypeAdapter<CardDetails> {
  @override
  final int typeId = 8;

  @override
  CardDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardDetails(
      cardId: fields[0] as String,
      cardNumber: fields[1] as String,
      expiryDate: fields[2] as String,
      cardHolderName: fields[3] as String,
      cvvCode: fields[4] as String,
      isCvvFocused: fields[5] as bool,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CardDetails obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.expiryDate)
      ..writeByte(3)
      ..write(obj.cardHolderName)
      ..writeByte(4)
      ..write(obj.cvvCode)
      ..writeByte(5)
      ..write(obj.isCvvFocused)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
