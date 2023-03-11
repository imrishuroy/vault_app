import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/repositories/audios/audios_repository.dart';
import '/screens/audios/cubit/audios_cubit.dart';
import '/services/services.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';
import 'widgets/audio_player_widget.dart';

class AudiosScreen extends StatefulWidget {
  static const String routeName = '/audiosScreen';
  const AudiosScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => AudiosCubit(
          audioRepository: context.read<AudiosRepository>(),
        )..loadAudios(),
        child: const AudiosScreen(),
      ),
    );
  }

  @override
  State<AudiosScreen> createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final audiosCubit = context.read<AudiosCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audios'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => audiosCubit.pickAudios(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocConsumer<AudiosCubit, AudiosState>(
        listener: (context, state) {
          if (state.status == AudiosStatus.error) {
            showDialog(
              context: context,
              builder: (_) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
          if (state.status == AudiosStatus.success) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == AudiosStatus.loading) {
            return const LoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: state.audios.length,
                  itemBuilder: (context, index) {
                    final audio = state.audios[index];
                    return Card(
                      elevation: 1.0,
                      child: Dismissible(
                        background: Container(
                          color: Colors.redAccent,
                        ),
                        onDismissed: (_) async {
                          final result = await AskToAction.confirmDelete(
                            context: context,
                            title: 'Delete Audio',
                            message: 'Do you want to delete this audio?',
                          );
                          if (result) {
                            audiosCubit.deleteAudio(audio.audioId);
                          }
                        },
                        key: UniqueKey(),
                        child: ListTile(
                          title: Text(
                            audio.fileName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            timeago.format(audio.createdAt),
                          ),
                          leading: AudioPlayerWidget(
                            path: audio.secrectPath,
                          ),
                        ),
                      ),
                    );
                  },
                )

                    // GridView.builder(
                    //   itemCount: state.audios.length,
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 10.0,
                    //     mainAxisSpacing: 10.0,
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     final audio = state.audios[index];
                    //     return AudioPlayerWidget(path: audio.secrectPath);
                    //   },
                    // ),
                    )

                // ElevatedButton(
                //   onPressed: () async {
                //     await player.play(DeviceFileSource(_pickedFile!.path));
                //     print('Audio cache ${player.audioCache}');
                //   },
                //   child: const Text('Play'),
                // ),
                //Image(image: image)
                // player.audioCache != null ?
                //Image.memory()
              ],
            ),
          );
        },
      ),
    );
  }
}
