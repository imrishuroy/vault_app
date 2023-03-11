part of 'notes_cubit.dart';

enum NotesStatus { initial, loading, success, loaded, error }

class NotesState extends Equatable {
  final List<Note> notes;
  final String noteTitle;
  final String noteContent;
  final Failure failure;
  final NotesStatus status;

  const NotesState({
    required this.notes,
    required this.noteTitle,
    required this.noteContent,
    required this.failure,
    required this.status,
  });

  NotesState copyWith({
    List<Note>? notes,
    String? noteTitle,
    String? noteContent,
    Failure? failure,
    NotesStatus? status,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      noteTitle: noteTitle ?? this.noteTitle,
      noteContent: noteContent ?? this.noteContent,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  factory NotesState.initial() => const NotesState(
        notes: [],
        noteTitle: '',
        noteContent: '',
        failure: Failure(),
        status: NotesStatus.initial,
      );

  bool get formIsValid => noteTitle.isNotEmpty && noteContent.isNotEmpty;

  @override
  String toString() {
    return 'NotesState(notes: $notes, noteTitle: $noteTitle, noteContent: $noteContent, failure: $failure, status: $status)';
  }

  @override
  List<Object> get props {
    return [
      notes,
      noteTitle,
      noteContent,
      failure,
      status,
    ];
  }
}
