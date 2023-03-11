import 'package:hive_flutter/hive_flutter.dart';

import '/config/hive_config.dart';
import '/models/failure.dart';
import '/models/image_file.dart';
import 'base_images_repo.dart';

class ImagesRepository extends BaseImagesRepository {
  @override
  Future<void> addImage(ImageFile file) async {
    try {
      await HiveConfig().addImages(file);
    } on HiveError catch (error) {
      print('Error in adding image ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding image ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  List<ImageFile> getImages() {
    try {
      return HiveConfig().getImages();
    } on HiveError catch (error) {
      print('Error in getting images ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting images ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> deleteImage(String imageId) async {
    try {
      await HiveConfig().deleteImage(imageId);
    } on HiveError catch (error) {
      print('Error in deleting image ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting image ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
