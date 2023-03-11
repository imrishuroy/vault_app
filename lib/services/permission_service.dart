import 'dart:io' as io;

import 'package:permission_handler/permission_handler.dart';

import '/models/failure.dart';

class PermissionService {
  static Future<bool> _requestPermission(Permission permission) async {
    try {
      return await permission.request().isGranted;
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }

  static Future<bool> checkStoragePermission() async {
    try {
      if (io.Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            // access media location needed for android 10/Q
            await _requestPermission(Permission.accessMediaLocation) &&
            // manage external storage needed for android 11/R
            await _requestPermission(Permission.manageExternalStorage)) {
          return true;
        } else {
          return false;
        }
      }
      if (io.Platform.isIOS) {
        if (await _requestPermission(Permission.photos)) {
          return true;
        } else {
          return false;
        }
      } else {
        // not android or ios
        return false;
      }
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }
}
