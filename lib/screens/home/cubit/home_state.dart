part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final File? pickedImage;
  final Failure failure;

  final HomeStatus status;

  const HomeState({
    this.pickedImage,
    required this.failure,
    required this.status,
  });

  factory HomeState.initial() =>
      const HomeState(status: HomeStatus.initial, failure: Failure());

  @override
  List<Object?> get props => [pickedImage, failure, status];

  HomeState copyWith({
    File? pickedImage,
    Failure? failure,
    HomeStatus? status,
  }) {
    return HomeState(
      pickedImage: pickedImage ?? this.pickedImage,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'HomeState(pickedImage: $pickedImage, failure: $failure status: $status)';
}
