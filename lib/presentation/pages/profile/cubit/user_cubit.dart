import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(const UserState());

  Future<void> loadUserProfile() async {
    try {
      emit(state.copyWith(getProfileStatus: LoadStatus.LOADING, error: ''));

      final response = await userRepository.getUserProfile();
      if (response.success && response.data != null) {
        UserProfile userProfile = response.data!;
        final user = UserEntity.fromUserProfile(userProfile);
        emit(
          state.copyWith(
            getProfileStatus: LoadStatus.SUCCESS,
            user: user,
            error: '',
          ),
        );
      } else {
        emit(state.copyWith(
          getProfileStatus: LoadStatus.FAILURE,
          error: response.error ?? 'Failed to load profile',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        getProfileStatus: LoadStatus.FAILURE,
        error: 'Failed to load profile: ${e.toString()}',
      ));
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true, error: ''));

      await SharedPreferencesHelper.removeByKey(
          SharedPreferencesHelper.ACCESS_TOKEN);
      await SharedPreferencesHelper.removeByKey(
          SharedPreferencesHelper.REFRESH_TOKEN);

      // Navigate to login screen or clear user session
      // This will be implemented when repository is ready
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to logout: ${e.toString()}',
      ));
    }
  }

  Future<void> updateProfile(UpdateProfileRequest body) async {
    try {
      emit(state.copyWith(updateStatus: LoadStatus.LOADING, error: ''));

      final response = await userRepository.updateProfile(body);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          updateStatus: LoadStatus.SUCCESS,
          error: '',
        ));
      } else {
        emit(state.copyWith(
          updateStatus: LoadStatus.FAILURE,
          error: response.error ?? 'Failed to update profile',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        updateStatus: LoadStatus.FAILURE,
        error: 'Failed to update profile: ${e.toString()}',
      ));
    }
  }
}
