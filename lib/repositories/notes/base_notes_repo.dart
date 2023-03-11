import '/models/note.dart';

abstract class BaseNotesRepository {
  List<Note> getAllNotes();
  Note? getNote(int id);
  Future<void> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}
