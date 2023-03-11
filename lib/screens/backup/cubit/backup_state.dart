part of 'backup_cubit.dart';

enum BackUpStatus { initial, submitting, success, error }

class BackUpState extends Equatable {
  final BackUpStatus status;
  final Failure failure;

  const BackUpState({
    required this.status,
    required this.failure,
  });

  factory BackUpState.initial() => const BackUpState(
        status: BackUpStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props => [status, failure];

  BackUpState copyWith({
    BackUpStatus? status,
    Failure? failure,
  }) {
    return BackUpState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() => 'BackUpState(status: $status, failure: $failure)';
}
