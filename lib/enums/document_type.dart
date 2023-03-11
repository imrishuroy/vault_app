import 'package:hive/hive.dart';

part 'document_type.g.dart';

@HiveType(typeId: 11)
enum DocumentType {
  @HiveField(0)
  pdf,
  @HiveField(1)
  excel,
  @HiveField(2)
  txt,
  @HiveField(3)
  other
}
