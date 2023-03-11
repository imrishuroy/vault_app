import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'image_file.g.dart';

@HiveType(typeId: 1)
class ImageFile extends Equatable {
  @HiveField(0)
  final String imageId;
  @HiveField(1)
  final String fileName;
  @HiveField(2)
  final String originPath;
  @HiveField(3)
  final String? remoteUrl;
  @HiveField(4)
  final String secrectPath;
  @HiveField(5)
  final DateTime createdAt;

  const ImageFile({
    required this.imageId,
    required this.fileName,
    required this.originPath,
    this.remoteUrl,
    required this.secrectPath,
    required this.createdAt,
  });

  ImageFile copyWith({
    String? imageId,
    String? fileName,
    String? originPath,
    String? remoteUrl,
    String? secrectPath,
    DateTime? createdAt,
  }) {
    return ImageFile(
      imageId: imageId ?? this.imageId,
      fileName: fileName ?? this.fileName,
      originPath: originPath ?? this.originPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      secrectPath: secrectPath ?? this.secrectPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'imageId': imageId});
    result.addAll({'fileName': fileName});
    result.addAll({'originPath': originPath});
    result.addAll({'remoteUrl': remoteUrl});
    result.addAll({'secrectPath': secrectPath});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory ImageFile.fromMap(Map<String, dynamic> map) {
    return ImageFile(
      imageId: map['imageId'] ?? '',
      fileName: map['fileName'] ?? '',
      originPath: map['originPath'] ?? '',
      remoteUrl: map['remoteUrl'] ?? '',
      secrectPath: map['secrectPath'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageFile.fromJson(String source) =>
      ImageFile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ImageFile(imageId: $imageId, fileName: $fileName, originPath: $originPath, remoteUrl: $remoteUrl, secrectPath: $secrectPath, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      imageId,
      fileName,
      originPath,
      remoteUrl,
      secrectPath,
      createdAt,
    ];
  }
}
