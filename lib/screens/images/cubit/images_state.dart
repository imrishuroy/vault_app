part of 'images_cubit.dart';

enum ImagesStatus { initial, loading, loaded, success, error }

class ImagesState extends Equatable {
  final File? pickedImage;
  final ImagesStatus status;
  final List<ImageFile> images;
  final Failure failure;

  const ImagesState({
    this.pickedImage,
    required this.status,
    required this.images,
    required this.failure,
  });

  factory ImagesState.initial() => const ImagesState(
        status: ImagesStatus.initial,
        images: [],
        failure: Failure(),
      );

  @override
  List<Object?> get props => [pickedImage, status, images, failure];

  ImagesState copyWith({
    File? pickedImage,
    ImagesStatus? status,
    List<ImageFile>? images,
    Failure? failure,
  }) {
    return ImagesState(
      pickedImage: pickedImage ?? this.pickedImage,
      status: status ?? this.status,
      images: images ?? this.images,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() {
    return 'ImagesState(pickedImage: $pickedImage, status: $status, images: $images, failure: $failure)';
  }
}
