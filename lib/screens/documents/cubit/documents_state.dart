part of 'documents_cubit.dart';

enum DocumentsStatus { initial, loading, loaded, error }

class DocumentsState extends Equatable {
  final List<Document> textDocumentsList;
  final List<Document> excelDocumentsList;
  final List<Document> pdfDocumentsList;
  final List<Document> pickedDocuments;
  final DocumentsStatus status;
  final Failure failure;

  const DocumentsState({
    required this.textDocumentsList,
    required this.excelDocumentsList,
    required this.pdfDocumentsList,
    required this.pickedDocuments,
    required this.status,
    required this.failure,
  });

  factory DocumentsState.initial() => const DocumentsState(
        textDocumentsList: [],
        excelDocumentsList: [],
        pdfDocumentsList: [],
        pickedDocuments: [],
        status: DocumentsStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props {
    return [
      textDocumentsList,
      excelDocumentsList,
      pdfDocumentsList,
      pickedDocuments,
      status,
      failure,
    ];
  }

  DocumentsState copyWith({
    List<Document>? textDocumentsList,
    List<Document>? excelDocumentsList,
    List<Document>? pdfDocumentsList,
    List<Document>? pickedDocuments,
    DocumentsStatus? status,
    Failure? failure,
  }) {
    return DocumentsState(
      textDocumentsList: textDocumentsList ?? this.textDocumentsList,
      excelDocumentsList: excelDocumentsList ?? this.excelDocumentsList,
      pdfDocumentsList: pdfDocumentsList ?? this.pdfDocumentsList,
      pickedDocuments: pickedDocuments ?? this.pickedDocuments,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() {
    return 'DocumentsState(textDocumentsList: $textDocumentsList, excelDocumentsList: $excelDocumentsList, pdfDocumentsList: $pdfDocumentsList, pickedDocuments: $pickedDocuments, status: $status, failure: $failure)';
  }
}
