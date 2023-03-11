import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '/repositories/notes/notes_repository.dart';
import '/screens/notes/add_notes_screen.dart';
import '/screens/notes/cubit/notes_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class NotesScreen extends StatelessWidget {
  static const String routeName = '/notes';

  const NotesScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => NotesCubit(
          notesRepository: context.read<NotesRepository>(),
        )..loadNotes(),
        child: const NotesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteCubit = context.read<NotesCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          AddNotesScreen.routeName,
          arguments: AddNotesArgs(notesCubit: noteCubit),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state.status == NotesStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NotesStatus.loading) {
            return const LoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                      itemCount: state.notes.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: const Center(
                                    child: Text(
                                      'Deleting...',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                key: Key(note.id),
                                onDismissed: (direction) {
                                  noteCubit.deleteNote(note.id);
                                },
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    AddNotesScreen.routeName,
                                    arguments: AddNotesArgs(
                                        notesCubit: noteCubit, note: note),
                                  ),
                                  title: Text(note.title),
                                  subtitle: Text(note.content),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
