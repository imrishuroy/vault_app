import 'package:hive_flutter/hive_flutter.dart';

import '/config/hive_config.dart';
import '/models/failure.dart';
import '/models/note.dart';
import '/repositories/notes/base_notes_repo.dart';

class NotesRepository extends BaseNotesRepository {
  @override
  Future<void> createNote(Note note) async {
    try {
      await HiveConfig().addNote(note);
    } on HiveError catch (error) {
      print('Error in adding note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await HiveConfig().deleteNote(id);
    } on HiveError catch (error) {
      print('Error in deleting note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  List<Note> getAllNotes() {
    try {
      return HiveConfig().getAllNotes();
    } on HiveError catch (error) {
      print('Error in getting notes ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting notes ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Note? getNote(int id) {
    try {
      return HiveConfig().getNote(id);
    } on HiveError catch (error) {
      print('Error in getting notes ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting notes ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> updateNote(Note note) async {
    try {
      await HiveConfig().updateNote(note);
    } on HiveError catch (error) {
      print('Error in updating note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in updating note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
