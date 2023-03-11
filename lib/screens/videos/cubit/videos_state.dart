part of 'videos_cubit.dart';

enum VideosStatus { initial, loading, loaded, success, error }

class VideosState extends Equatable {
  final List<VideoFile> videos;
  final VideoFile? videoFile;
  final File? pickedVideo;
  final VideosStatus status;
  final Failure failure;

  const VideosState({
    required this.videos,
    this.videoFile,
    this.pickedVideo,
    required this.status,
    required this.failure,
  });

  factory VideosState.initial() => const VideosState(
        videos: [],
        status: VideosStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object?> get props {
    return [
      videos,
      videoFile,
      pickedVideo,
      status,
      failure,
    ];
  }

  VideosState copyWith({
    List<VideoFile>? videos,
    VideoFile? videoFile,
    File? pickedVideo,
    VideosStatus? status,
    Failure? failure,
  }) {
    return VideosState(
      videos: videos ?? this.videos,
      videoFile: videoFile ?? this.videoFile,
      pickedVideo: pickedVideo ?? this.pickedVideo,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() {
    return 'VideosState(videos: $videos, videoFile: $videoFile, pickedVideo: $pickedVideo, status: $status, failure: $failure)';
  }
}
