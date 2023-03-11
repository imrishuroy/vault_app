import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/widgets/loading_indicator.dart';

import '/repositories/videos/videos_repository.dart';
import '/screens/videos/cubit/videos_cubit.dart';
import '/services/services.dart';
import '/widgets/error_dialog.dart';
import 'widgets/custom_video_player.dart';

class VideosScreen extends StatelessWidget {
  static const String routeName = '/videos';
  const VideosScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => VideosCubit(
          videoRepository: context.read<VideosRepository>(),
        )..loadVideos(),
        child: const VideosScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideosCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async => videoCubit.pickVideos(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: BlocConsumer<VideosCubit, VideosState>(
        listener: (context, state) {
          if (state.status == VideosStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == VideosStatus.loading) {
            return const LoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                key: const Key('videos_list'),
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        final result = await AskToAction.confirmDelete(
                          context: context,
                          title: 'Delete Video',
                          message: 'Do you want to delete this video ?',
                        );

                        if (result) {
                          videoCubit.deleteVideo(video.videoId);
                        }
                      },
                      background: Container(
                        color: Colors.red,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                      ),
                      key: UniqueKey(),
                      // key: ValueKey<String>(video.videoId),
                      child: CustomVideoPlayer(
                        videoFilePath: video.secrectPath,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
