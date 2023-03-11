import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '/models/failure.dart';
import '/models/video_file.dart';
import '/repositories/videos/videos_repository.dart';
import '/services/services.dart';
import '/utils/utils.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  final VideosRepository _videoRepository;
  VideosCubit({required VideosRepository videoRepository})
      : _videoRepository = videoRepository,
        super(VideosState.initial());

  void pickVideos(BuildContext context) async {
    try {
      emit(state.copyWith(status: VideosStatus.loading));
      if (await PermissionService.checkStoragePermission()) {
        final pickedFiles = await MediaUtil.pickFiles(
            context: context, requestType: RequestType.video);
        final directory = await getApplicationDocumentsDirectory();
        print('Directory ----: ${directory.path}');

        print('Picked videos -- $pickedFiles');

        for (var pickedFile in pickedFiles) {
          if (pickedFile != null) {
            print('Picked video -- ${pickedFile.path}');
            final fileName = basename(pickedFile.path);
            File tmpFile = File(pickedFile.path);
            final String fileExtension = extension(pickedFile.path);

            tmpFile =
                await tmpFile.copy('${directory.path}/$fileName$fileExtension');

            print('Secrect file: $tmpFile');

            final videoFile = VideoFile(
              fileName: fileName,
              videoId: const Uuid().v4(),
              originPath: pickedFile.path,
              secrectPath: tmpFile.path,
              createdAt: DateTime.now(),
            );

            await _videoRepository.addVideo(videoFile);
          }
        }

        loadVideos();
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: VideosStatus.error));
    } catch (error) {
      emit(
        state.copyWith(
            failure: Failure(message: error.toString()),
            status: VideosStatus.error),
      );
      print('Error in picking videos ${error.toString()}');
    }
  }

  void addVideo(VideoFile file) async {
    try {
      emit(state.copyWith(status: VideosStatus.loading));
      await _videoRepository.addVideo(file);
      emit(state.copyWith(status: VideosStatus.success));
    } on Failure catch (failure) {
      emit(state.copyWith(status: VideosStatus.error, failure: failure));
    }
  }

  void loadVideos() {
    try {
      emit(state.copyWith(status: VideosStatus.loading));
      final videos = _videoRepository.getVideos();
      emit(state.copyWith(status: VideosStatus.loaded, videos: videos));
    } on Failure catch (failure) {
      emit(state.copyWith(status: VideosStatus.error, failure: failure));
    }
  }

  void deleteVideo(String videoId) async {
    try {
      emit(state.copyWith(status: VideosStatus.loading));
      await _videoRepository.deleteVideo(videoId);
      loadVideos();
    } on Failure catch (failure) {
      emit(state.copyWith(status: VideosStatus.error, failure: failure));
    }
  }
}
