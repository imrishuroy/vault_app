import '/repositories/file/base_file_repository.dart';

class FileRepository extends BaseFileRepository {
  // Future<void> addImage(SecrectFile file) async {
  //   try {
  //     await HiveConfig().addImages(file);
  //   } on HiveError catch (error) {
  //     print('Error in adding image ${error.message}');
  //     throw Failure(message: error.message);
  //   } catch (error) {
  //     print('Error in adding image ${error.toString}');
  //     throw Failure(message: error.toString());
  //   }
  // }

  // List<SecrectFile> getImages() {
  //   try {
  //     return HiveConfig().getImages();
  //   } on HiveError catch (error) {
  //     print('Error in getting images ${error.message}');
  //     throw Failure(message: error.message);
  //   } catch (error) {
  //     print('Error in getting images ${error.toString}');
  //     throw Failure(message: error.toString());
  //   }
  // }

  // Future<void> addVideo(SecrectFile file) async {
  //   try {
  //     await HiveConfig().addVideos(file);
  //   } on HiveError catch (error) {
  //     print('Error in adding video ${error.message}');
  //     throw Failure(message: error.message);
  //   } catch (error) {
  //     print('Error in adding video ${error.toString}');
  //     throw Failure(message: error.toString());
  //   }
  // }

  // List<SecrectFile> getVideos() {
  //   try {
  //     return HiveConfig().getVideos();
  //   } on HiveError catch (error) {
  //     print('Error in getting videos ${error.message}');
  //     throw Failure(message: error.message);
  //   } catch (error) {
  //     print('Error in getting videos ${error.toString}');
  //     throw Failure(message: error.toString());
  //   }
  // }
}
