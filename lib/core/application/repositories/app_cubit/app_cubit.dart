import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  Future<void> saveUserProfile(UserProfile userProfile) async {
    emit(state.copyWith(
      userProfile: userProfile,
    ));
  }
}
