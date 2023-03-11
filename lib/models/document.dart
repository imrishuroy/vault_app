import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '/enums/document_type.dart';

part 'document.g.dart';

@HiveType(typeId: 4)
class Document extends Equatable {
  @HiveField(0)
  final String documentId;
  @HiveField(1)
  final DocumentType documentType;
  @HiveField(2)
  final String originPath;
  @HiveField(3)
  final String secrectPath;
  @HiveField(4)
  final String fileName;
  @HiveField(5)
  final String? remoteUrl;
  @HiveField(6)
  final DateTime createdAt;

  const Document({
    required this.documentId,
    required this.documentType,
    required this.originPath,
    required this.secrectPath,
    required this.fileName,
    this.remoteUrl,
    required this.createdAt,
  });

  Document copyWith({
    String? documentId,
    DocumentType? documentType,
    String? originPath,
    String? secrectPath,
    String? fileName,
    String? remoteUrl,
    DateTime? createdAt,
  }) {
    return Document(
      documentId: documentId ?? this.documentId,
      documentType: documentType ?? this.documentType,
      originPath: originPath ?? this.originPath,
      secrectPath: secrectPath ?? this.secrectPath,
      fileName: fileName ?? this.fileName,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'documentId': documentId});
    result.addAll({'documentType': EnumToString.convertToString(documentType)});

    result.addAll({'originPath': originPath});
    result.addAll({'secrectPath': secrectPath});
    result.addAll({'fileName': fileName});
    if (remoteUrl != null) {
      result.addAll({'remoteUrl': remoteUrl});
    }
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      documentId: map['documentId'] ?? '',
      documentType: (map['documentType'] != null
              ? EnumToString.fromString(
                  DocumentType.values, map['documentType'])
              : DocumentType.other) ??
          DocumentType.other,
      originPath: map['originPath'] ?? '',
      secrectPath: map['secrectPath'] ?? '',
      fileName: map['fileName'] ?? '',
      remoteUrl: map['remoteUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Document(documentId: $documentId, documentType: $documentType, originPath: $originPath, secrectPath: $secrectPath, fileName: $fileName, remoteUrl: $remoteUrl, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      documentId,
      documentType,
      originPath,
      secrectPath,
      fileName,
      remoteUrl,
      createdAt,
    ];
  }
}
