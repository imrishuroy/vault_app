import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '/models/failure.dart';
import '/models/note.dart';
import '/repositories/notes/notes_repository.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _notesRepository;
  NotesCubit({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(NotesState.initial());

  void loadNotes() {
    try {
      emit(state.copyWith(status: NotesStatus.loading));

      final notes = _notesRepository.getAllNotes();
      emit(state.copyWith(notes: notes, status: NotesStatus.loaded));
    } on Failure catch (failure) {
      emit(state.copyWith(status: NotesStatus.error, failure: failure));
    }
  }

  void noteTileChanged(String value) {
    emit(state.copyWith(noteTitle: value, status: NotesStatus.initial));
  }

  void noteContentChanged(String value) {
    emit(state.copyWith(noteContent: value, status: NotesStatus.initial));
  }

  void createNote() async {
    try {
      print('This notes runs 3');

      print('title = ${state.noteTitle}');
      print('content = ${state.noteContent}');

      if (!state.formIsValid) return;
      print('This notes runs 4');
      emit(state.copyWith(status: NotesStatus.loading));
      final note = Note(
        id: const Uuid().v4(),
        title: state.noteTitle,
        content: state.noteContent,
        createdAt: DateTime.now(),
      );
      print('This notes runs 5 ${note.toString}');
      await _notesRepository.createNote(note);
      emit(
        state.copyWith(
          notes: [...state.notes, note],
          status: NotesStatus.success,
        ),
      );
      print('This notes runs 6');
    } on Failure catch (failure) {
      emit(state.copyWith(status: NotesStatus.error, failure: failure));
    }
  }

  void updateNote(Note note) async {
    try {
      emit(state.copyWith(status: NotesStatus.loading));

      final updatedNote = note.copyWith(
        title: state.noteTitle.isNotEmpty ? state.noteTitle : note.title,
        content:
            state.noteContent.isNotEmpty ? state.noteContent : note.content,
      );

      await _notesRepository.updateNote(updatedNote);
      emit(
        state.copyWith(
          notes: state.notes.map((note) {
            return note.id == updatedNote.id ? updatedNote : note;
          }).toList(),
          status: NotesStatus.success,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: NotesStatus.error, failure: failure));
    }
  }

  void deleteNote(String id) async {
    try {
      await _notesRepository.deleteNote(id);
      emit(
        state.copyWith(
          notes: state.notes.where((note) => note.id != id).toList(),
          status: NotesStatus.loaded,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: NotesStatus.error, failure: failure));
    }
  }
}
