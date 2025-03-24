import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/utils/share_preferrences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(const UserState());

  Future<void> loadUserProfile() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await userRepository.getUserProfile();
      emit(state.copyWith(
        isLoading: false,
        fullName: response.data?.fullName,
        username: response.data?.username,
        signature: response.data?.signature,
        avatarUrl: response.data?.avatar,
        followingCount: response.data?.count.followings,
        followersCount: response.data?.count.followers,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load profile: ${e.toString()}',
      ));
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

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

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
