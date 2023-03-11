import '/models/image_file.dart';

abstract class BaseImagesRepository {
  Future<void> addImage(ImageFile file);
  List<ImageFile> getImages();
  Future<void> deleteImage(String imageId);
}
