import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void pauseVideo() {
    emit(state.copyWith(
      isVideoPlaying: false,
    ));
  }

  void playVideo() {
    emit(state.copyWith(
      isVideoPlaying: true,
    ));
  }

  Future<void> saveUserProfile(UserEntity userProfile) async {
    emit(state.copyWith(
      userProfile: userProfile,
    ));
  }
}
