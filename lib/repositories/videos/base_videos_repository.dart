import '/models/video_file.dart';

abstract class BaseVideosRepository {
  Future<void> addVideo(VideoFile file);
  List<VideoFile> getVideos();
  Future<void> deleteVideo(String videoId);
}
