import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/models/failure.dart';
import '/repositories/backup/backup_repository.dart';

part 'backup_state.dart';

class BackUpCubit extends Cubit<BackUpState> {
  final BackUpRepository _backUpRepository;

  BackUpCubit({required BackUpRepository backUpRepository})
      : _backUpRepository = backUpRepository,
        super(BackUpState.initial());

  void backupData({required String userId}) async {
    try {
      print('Downloading data');
      emit(state.copyWith(status: BackUpStatus.submitting));
      await _backUpRepository.backupData(userId);
      emit(state.copyWith(status: BackUpStatus.success));
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: BackUpStatus.error,
          failure: failure,
        ),
      );
    }
  }

  // download data from firebase
  void downloadData({required String userId}) async {
    try {
      emit(state.copyWith(status: BackUpStatus.submitting));
      await _backUpRepository.downloadData(userId: userId);

      emit(state.copyWith(status: BackUpStatus.success));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: BackUpStatus.error));
    }
  }
}
// bitbucket-hook/