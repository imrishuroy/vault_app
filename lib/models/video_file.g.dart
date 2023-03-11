// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoFileAdapter extends TypeAdapter<VideoFile> {
  @override
  final int typeId = 2;

  @override
  VideoFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoFile(
      videoId: fields[0] as String,
      fileName: fields[1] as String,
      originPath: fields[2] as String,
      secrectPath: fields[3] as String,
      remoteUrl: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VideoFile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.videoId)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.originPath)
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
      other is VideoFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
