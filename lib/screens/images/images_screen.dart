import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/screens/images/widgets/display_file_image.dart';

import '/repositories/images/images_repository.dart';
import '/services/services.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';
import 'cubit/images_cubit.dart';
import 'expanded_photo_view.dart';

class ImagesScreen extends StatelessWidget {
  static const String routeName = '/images';
  const ImagesScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ImagesCubit(
          imagesRepository: context.read<ImagesRepository>(),
        )..loadImages(),
        child: const ImagesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesCubit = context.read<ImagesCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async => imagesCubit.pickImages(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: BlocConsumer<ImagesCubit, ImagesState>(
        listener: (context, state) {
          if (state.status == ImagesStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ImagesStatus.loading) {
            return const LoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: state.images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  final image = state.images[index];
                  final imageFile = File(image.secrectPath);
                  return GestureDetector(
                      onLongPress: () async {
                        final result = await AskToAction.confirmDelete(
                          context: context,
                          title: 'Delete Image',
                          message: 'Do you want to delete this image?',
                        );

                        if (result) {
                          imagesCubit.deleteImage(image.imageId);
                        }
                      },
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExpandedPhotoView(file: imageFile),
                            ),
                          ),
                      child: DisplayFileImage(file: imageFile));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
