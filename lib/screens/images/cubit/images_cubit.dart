import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vault_app/services/permission_service.dart';
import 'package:vault_app/utils/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '/models/failure.dart';
import '/models/image_file.dart';
import '/repositories/images/images_repository.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImagesRepository _imagesRepository;
  ImagesCubit({required ImagesRepository imagesRepository})
      : _imagesRepository = imagesRepository,
        super(ImagesState.initial());

  void pickImages(BuildContext context) async {
    try {
      emit(state.copyWith(status: ImagesStatus.loading));
      if (await PermissionService.checkStoragePermission()) {
        final pickedFiles = await MediaUtil.pickFiles(
            context: context, requestType: RequestType.image);
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

            final imageFile = ImageFile(
              fileName: fileName,
              imageId: const Uuid().v4(),
              originPath: pickedFile.path,
              secrectPath: tmpFile.path,
              createdAt: DateTime.now(),
            );

            await _imagesRepository.addImage(imageFile);
          }
        }

        loadImages();
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ImagesStatus.error));
    } catch (error) {
      emit(
        state.copyWith(
            failure: Failure(message: error.toString()),
            status: ImagesStatus.error),
      );
      print('Error in picking videos ${error.toString()}');
    }
  }

  void loadImages() {
    try {
      emit(state.copyWith(status: ImagesStatus.loading));
      final images = _imagesRepository.getImages();
      emit(state.copyWith(status: ImagesStatus.loaded, images: images));
    } on Failure catch (failure) {
      emit(state.copyWith(status: ImagesStatus.error, failure: failure));
    }
  }

  void deleteImage(String imageId) async {
    try {
      emit(state.copyWith(status: ImagesStatus.loading));
      await _imagesRepository.deleteImage(imageId);
      loadImages();
    } on Failure catch (failure) {
      emit(state.copyWith(status: ImagesStatus.error, failure: failure));
    }
  }
}
