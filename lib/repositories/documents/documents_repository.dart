import 'package:hive_flutter/hive_flutter.dart';

import '/config/hive_config.dart';
import '/models/document.dart';
import '/models/failure.dart';
import '/repositories/documents/base_documents_repo.dart';

class DocumentsRepository extends BaseDocumentsRepo {
  List<Document> getTextFiles() {
    try {
      return HiveConfig().getTexts();
    } on HiveError catch (error) {
      print('Error in getting texts ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting texts ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  List<Document> getExcelFiles() {
    try {
      return HiveConfig().getExcels();
    } on HiveError catch (error) {
      print('Error in getting excels ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting excels ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  List<Document> getPdfFiles() {
    try {
      return HiveConfig().getPdfs();
    } on HiveError catch (error) {
      print('Error in getting pdfs ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting pdfs ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> addDocument(Document document) async {
    try {
      print('this bank runs  - 3 ${document.toString()}');
      await HiveConfig().addDocument(document);
    } on HiveError catch (error) {
      print('Error in updating password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  Future<void> deleteDocument(Document document) async {
    try {
      print('this bank runs  - 3 ${document.toString()}');
      await HiveConfig().deleteDocument(document);
    } on HiveError catch (error) {
      print('Error in updating password ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating password ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
