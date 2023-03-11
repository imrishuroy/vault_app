import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'audio_file.g.dart';

@HiveType(typeId: 3)
class AudioFile extends Equatable {
  @HiveField(0)
  final String audioId;
  @HiveField(1)
  final String originPath;
  @HiveField(2)
  final String fileName;
  @HiveField(3)
  final String secrectPath;
  @HiveField(4)
  final String? remoteUrl;
  @HiveField(5)
  final DateTime createdAt;

  const AudioFile({
    required this.audioId,
    required this.originPath,
    required this.fileName,
    required this.secrectPath,
    this.remoteUrl,
    required this.createdAt,
  });

  AudioFile copyWith({
    String? audioId,
    String? originPath,
    String? fileName,
    String? secrectPath,
    String? remoteUrl,
    DateTime? createdAt,
  }) {
    return AudioFile(
      audioId: audioId ?? this.audioId,
      originPath: originPath ?? this.originPath,
      fileName: fileName ?? this.fileName,
      secrectPath: secrectPath ?? this.secrectPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'audioId': audioId});
    result.addAll({'originPath': originPath});
    result.addAll({'fileName': fileName});
    result.addAll({'secrectPath': secrectPath});
    result.addAll({'remoteUrl': remoteUrl});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory AudioFile.fromMap(Map<String, dynamic> map) {
    return AudioFile(
      audioId: map['audioId'] ?? '',
      originPath: map['originPath'] ?? '',
      fileName: map['fileName'] ?? '',
      secrectPath: map['secrectPath'] ?? '',
      remoteUrl: map['remoteUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioFile.fromJson(String source) =>
      AudioFile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AudioFile(audioId: $audioId, originPath: $originPath, fileName: $fileName, secrectPath: $secrectPath, remoteUrl: $remoteUrl, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      audioId,
      originPath,
      fileName,
      secrectPath,
      remoteUrl,
      createdAt,
    ];
  }
}
