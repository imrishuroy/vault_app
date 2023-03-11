import 'package:hive_flutter/hive_flutter.dart';

import '/config/hive_config.dart';
import '/models/failure.dart';
import '/models/video_file.dart';
import 'base_videos_repository.dart';

class VideosRepository extends BaseVideosRepository {
  @override
  Future<void> addVideo(VideoFile file) async {
    try {
      await HiveConfig().addVideos(file);
    } on HiveError catch (error) {
      print('Error in adding video ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in adding video ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  List<VideoFile> getVideos() {
    try {
      return HiveConfig().getVideos();
    } on HiveError catch (error) {
      print('Error in getting videos ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in getting videos ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> deleteVideo(String videoId) async {
    try {
      await HiveConfig().deleteVideo(videoId);
    } on HiveError catch (error) {
      print('Error in deleting video ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting video ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
