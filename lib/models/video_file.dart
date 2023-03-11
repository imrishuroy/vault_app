import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'video_file.g.dart';

@HiveType(typeId: 2)
class VideoFile extends Equatable {
  @HiveField(0)
  final String videoId;
  @HiveField(1)
  final String fileName;
  @HiveField(2)
  final String originPath;
  @HiveField(3)
  final String secrectPath;
  @HiveField(4)
  final String? remoteUrl;
  @HiveField(5)
  final DateTime createdAt;

  const VideoFile({
    required this.videoId,
    required this.fileName,
    required this.originPath,
    required this.secrectPath,
    this.remoteUrl,
    required this.createdAt,
  });

  VideoFile copyWith({
    String? videoId,
    String? fileName,
    String? originPath,
    String? secrectPath,
    String? remoteUrl,
    DateTime? createdAt,
  }) {
    return VideoFile(
      videoId: videoId ?? this.videoId,
      fileName: fileName ?? this.fileName,
      originPath: originPath ?? this.originPath,
      secrectPath: secrectPath ?? this.secrectPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'videoId': videoId});
    result.addAll({'fileName': fileName});
    result.addAll({'originPath': originPath});
    result.addAll({'secrectPath': secrectPath});
    result.addAll({'remoteUrl': remoteUrl});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory VideoFile.fromMap(Map<String, dynamic> map) {
    return VideoFile(
      videoId: map['videoId'] ?? '',
      fileName: map['fileName'] ?? '',
      originPath: map['originPath'] ?? '',
      secrectPath: map['secrectPath'] ?? '',
      remoteUrl: map['remoteUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoFile.fromJson(String source) =>
      VideoFile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VideoFile(videoId: $videoId, fileName: $fileName, originPath: $originPath, secrectPath: $secrectPath, remoteUrl: $remoteUrl, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      videoId,
      fileName,
      originPath,
      secrectPath,
      remoteUrl,
      createdAt,
    ];
  }
}
