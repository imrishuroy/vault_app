import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_app/models/failure.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void pickImage(File pickedImage) {
    emit(state.copyWith(status: HomeStatus.loading));

    emit(state.copyWith(pickedImage: pickedImage, status: HomeStatus.success));
  }
}
