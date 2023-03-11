import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '/models/failure.dart';

class MediaUtil {
  static Future<List<File?>> pickFiles({
    required BuildContext context,
    int? imageQuality,
    required RequestType requestType,
  }) async {
    try {
      List<File> files = [];
      final List<AssetEntity>? pickedFiles = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: requestType,
        ),
      );

      print('Picked video files -- $pickedFiles');

      for (var assetEntity in pickedFiles ?? []) {
        final file = await assetEntity.file;

        if (file != null) {
          files.add(file);
        }
      }

      print('Picked videos 2 -- $files');

      return files;
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }

  static Future<File?> pickVideo({required String title}) async {
    try {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (error) {
      print('Error in picking images  ${error.toString()}');
      throw const Failure(message: 'Error in picking video');
    }
  }

  deleteFile(File file) {
    file.delete();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path $path');
    return File('$path/counter.txt');
  }

  Future<int?> deleteFileI() async {
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {
      return 0;
    }
    return null;
  }

  static Future<List<File>> pickDocuments(
      {required String fileExtension}) async {
    try {
      print('Extension - $fileExtension');
      List<File> pickedDocs = [];
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileExtension],
      );
      print('Picked files -- $pickedFile');

      for (PlatformFile? file in pickedFile?.files ?? []) {
        if (file?.path != null) {
          print('File path -- ${file?.path}');
          pickedDocs.add(File(file!.path!));
        }
      }

      return pickedDocs;
    } catch (error) {
      print('Error in picking documents  ${error.toString()}');
      throw const Failure(message: 'Error in picking documents');
    }
  }

  static Future<List<File>> pickAudioFile() async {
    try {
      List<File> audioFiles = [];
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        allowedExtensions: ['mp3', 'wav'],
      );

      for (PlatformFile? item in result?.files ?? []) {
        print('Platform file ${item?.path}');
        if (item?.path != null) {
          final file = File(item!.path!);
          audioFiles.add(file);
        }
      }

      return audioFiles;
    } catch (error) {
      throw Failure(message: 'Error in picking audio file ${error.toString()}');
    }
  }

  // upload file to firebase storage

  static Future<String> uploadMediaToStorage(
    File file,
    String userId,
    String collectionName,
  ) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // creating location to our firebase storage

    Reference ref = storage.ref().child(collectionName).child(userId);

    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
