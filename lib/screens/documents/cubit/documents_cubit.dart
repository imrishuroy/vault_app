import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '/enums/document_type.dart';
import '/models/document.dart';
import '/models/failure.dart';
import '/repositories/documents/documents_repository.dart';
import '/utils/utils.dart';

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  final DocumentsRepository _docsRepo;
  DocumentsCubit({
    required DocumentsRepository documentsRepo,
  })  : _docsRepo = documentsRepo,
        super(DocumentsState.initial());

  void loadDocument() async {
    try {
      emit(state.copyWith(status: DocumentsStatus.loading));
      final excelDocs = _docsRepo.getExcelFiles();
      final pdfDocs = _docsRepo.getPdfFiles();
      print('Pdlkmldma -- $pdfDocs');
      final textDocs = _docsRepo.getTextFiles();

      emit(
        state.copyWith(
          excelDocumentsList: excelDocs,
          pdfDocumentsList: pdfDocs,
          textDocumentsList: textDocs,
          status: DocumentsStatus.loaded,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: DocumentsStatus.error));
    }
  }

  void pickDocument({required DocumentType documentType}) async {
    try {
      emit(state.copyWith(status: DocumentsStatus.loading));

      final pickedDocs = await MediaUtil.pickDocuments(
        fileExtension: _fileExtensionConverter(documentType),
      );

      final directory = await getApplicationDocumentsDirectory();
      print('Directory ----: ${directory.path}');

      print('PIcked images -- $pickedDocs');

      if (pickedDocs.isEmpty) {
        emit(state.copyWith(status: DocumentsStatus.initial));
        return;
      }

      for (var pickedFile in pickedDocs) {
        print('Picked image -- ${pickedFile.path}');
        final fileName = basename(pickedFile.path);
        File tmpFile = File(pickedFile.path);
        final String fileExtension = extension(pickedFile.path);

        tmpFile =
            await tmpFile.copy('${directory.path}/$fileName$fileExtension');

        //  final deletedFile = await pickedImage.delete();

        // print('deletedFile$deletedFile');

        print('Secrect file: $tmpFile');

        final document = Document(
          createdAt: DateTime.now(),
          documentId: const Uuid().v4(),
          originPath: pickedFile.path,
          secrectPath: tmpFile.path,
          fileName: fileName,
          documentType: documentType,
        );

        await _docsRepo.addDocument(document);

        loadDocument();
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: DocumentsStatus.error));
    }
  }

  void deleteDocument(Document document) async {
    try {
      emit(state.copyWith(status: DocumentsStatus.loading));
      await _docsRepo.deleteDocument(document);
      loadDocument();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: DocumentsStatus.error));
    }
  }

  String _fileExtensionConverter(DocumentType documentType) {
    switch (documentType) {
      case DocumentType.pdf:
        return 'pdf';
      case DocumentType.txt:
        return 'txt';
      case DocumentType.excel:
        return 'xlsx';
      default:
        return 'pdf';
    }
  }
}
