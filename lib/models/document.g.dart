// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 4;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      documentId: fields[0] as String,
      documentType: fields[1] as DocumentType,
      originPath: fields[2] as String,
      secrectPath: fields[3] as String,
      fileName: fields[4] as String,
      remoteUrl: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.documentId)
      ..writeByte(1)
      ..write(obj.documentType)
      ..writeByte(2)
      ..write(obj.originPath)
      ..writeByte(3)
      ..write(obj.secrectPath)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.remoteUrl)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
