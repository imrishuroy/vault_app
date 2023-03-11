import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/models/note.dart';

import '/screens/notes/cubit/notes_cubit.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class AddNotesArgs {
  final Note? note;
  final NotesCubit notesCubit;

  const AddNotesArgs({
    this.note,
    required this.notesCubit,
  });
}

class AddNotesScreen extends StatefulWidget {
  final Note? note;
  static const String routeName = '/add-notes';
  const AddNotesScreen({Key? key, this.note}) : super(key: key);

  static Route route({required AddNotesArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider.value(
        value: args.notesCubit,
        child: AddNotesScreen(
          note: args.note,
        ),
      ),
    );
  }

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submit({required NotesCubit notesCubit, required bool isLoading}) {
    print('This notes runs 1');
    if (_formKey.currentState!.validate() && !isLoading) {
      print('This notes runs 2');
      if (widget.note != null) {
        print('This notes runs 8');
        notesCubit.updateNote(widget.note!);
      } else {
        notesCubit.createNote();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesCubit = context.read<NotesCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Update Note' : 'Add New Note'),
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
          if (state.status == NotesStatus.success) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == NotesStatus.loading) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      maxLength: 200,
                      maxLines: 2,
                      minLines: 1,
                      intialValue: widget.note?.title,
                      labelText: 'Title',
                      onChanged: notesCubit.noteTileChanged,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter note title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),
                    CustomTextField(
                      maxLength: 2000,
                      maxLines: 10,
                      minLines: 3,
                      intialValue: widget.note?.content,
                      labelText: 'Add Your Notes Content Here',
                      onChanged: notesCubit.noteContentChanged,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter note content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () => _submit(
                        notesCubit: notesCubit,
                        isLoading: state.status == NotesStatus.loading,
                      ),
                      child: const Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
