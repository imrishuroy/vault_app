import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '/models/failure.dart';
import '/repositories/audios/audios_repository.dart';
import '/services/services.dart';
import '/utils/utils.dart';
import '../../../models/audio_file.dart';

part 'audios_state.dart';

class AudiosCubit extends Cubit<AudiosState> {
  final AudiosRepository _audioRepository;
  AudiosCubit({required AudiosRepository audioRepository})
      : _audioRepository = audioRepository,
        super(AudiosState.initial());

  void loadAudios() {
    try {
      emit(state.copyWith(status: AudiosStatus.loading));
      final audios = _audioRepository.getAudios();
      emit(state.copyWith(audios: audios, status: AudiosStatus.loaded));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: AudiosStatus.error));
    }
  }

  void pickAudios(
    BuildContext context,
  ) async {
    try {
      emit(state.copyWith(status: AudiosStatus.loading));
      if (await PermissionService.checkStoragePermission()) {
        final pickedFiles = await MediaUtil.pickFiles(
            context: context, requestType: RequestType.audio);
        final directory = await getApplicationDocumentsDirectory();
        print('Directory ----: ${directory.path}');

        print('PIcked images -- $pickedFiles');

        for (var pickedFile in pickedFiles) {
          if (pickedFile != null) {
            print('Picked image -- ${pickedFile.path}');
            final fileName = basename(pickedFile.path);
            print('File name $fileName');
            File tmpFile = File(pickedFile.path);
            final String fileExtension = extension(pickedFile.path);

            tmpFile =
                await tmpFile.copy('${directory.path}/$fileName$fileExtension');

            print('Secrect file: $tmpFile');

            await _audioRepository.addAudio(
              AudioFile(
                audioId: const Uuid().v4(),
                originPath: pickedFile.path,
                fileName: fileName,
                secrectPath: tmpFile.path,
                createdAt: DateTime.now(),
              ),
            );
          }
        }
        loadAudios();
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: AudiosStatus.error));
    } catch (error) {
      emit(state.copyWith(
          failure: Failure(message: error.toString()),
          status: AudiosStatus.error));
      print('Error in picking audios  ${error.toString()}');
    }
  }

  void addAudio(AudioFile audio) {
    emit(state.copyWith(audios: [...state.audios, audio]));
  }

  void deleteAudio(String audioId) async {
    try {
      emit(state.copyWith(status: AudiosStatus.loading));
      await _audioRepository.deleteAudio(audioId);
      emit(state.copyWith(
          audios:
              state.audios.where((audio) => audio.audioId != audioId).toList(),
          status: AudiosStatus.loaded));
      loadAudios();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: AudiosStatus.error));
    }
  }
}
