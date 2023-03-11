part of 'audios_cubit.dart';

enum AudiosStatus { initial, loading, success, loaded, error }

class AudiosState extends Equatable {
  final List<AudioFile> audios;
  final List<File?> pickedFiles;
  final Failure failure;
  final AudiosStatus status;

  const AudiosState({
    required this.status,
    required this.audios,
    required this.pickedFiles,
    required this.failure,
  });

  factory AudiosState.initial() => const AudiosState(
        status: AudiosStatus.initial,
        audios: [],
        pickedFiles: [],
        failure: Failure(),
      );

  @override
  List<Object> get props => [audios, pickedFiles, failure, status];

  AudiosState copyWith({
    List<AudioFile>? audios,
    List<File?>? pickedFiles,
    Failure? failure,
    AudiosStatus? status,
  }) {
    return AudiosState(
      audios: audios ?? this.audios,
      pickedFiles: pickedFiles ?? this.pickedFiles,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'AudiosState(audios: $audios, pickedFiles: $pickedFiles, failure: $failure, status: $status)';
  }
}
