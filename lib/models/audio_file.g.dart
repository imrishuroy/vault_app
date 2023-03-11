// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioFileAdapter extends TypeAdapter<AudioFile> {
  @override
  final int typeId = 3;

  @override
  AudioFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioFile(
      audioId: fields[0] as String,
      originPath: fields[1] as String,
      fileName: fields[2] as String,
      secrectPath: fields[3] as String,
      remoteUrl: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.audioId)
      ..writeByte(1)
      ..write(obj.originPath)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.secrectPath)
      ..writeByte(4)
      ..write(obj.remoteUrl)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
