import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState());

  Future<void> loadUserProfile() async {
    try {
      emit(state.copyWith(getUserStatus: LoadStatus.LOADING, error: ''));

      final response = await _userRepository.getUserProfile();
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            getUserStatus: LoadStatus.SUCCESS,
            user: response.data,
            error: '',
          ),
        );
      } else {
        emit(state.copyWith(
          getUserStatus: LoadStatus.FAILURE,
          error: response.error ?? 'Failed to load profile',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        getUserStatus: LoadStatus.FAILURE,
        error: 'Failed to load profile: ${e.toString()}',
      ));
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(error: ''));

      await SharedPreferencesHelper.removeByKey(
          SharedPreferencesHelper.ACCESS_TOKEN);
      await SharedPreferencesHelper.removeByKey(
          SharedPreferencesHelper.REFRESH_TOKEN);

      // Navigate to login screen or clear user session
      // This will be implemented when repository is ready
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to logout: ${e.toString()}',
      ));
    }
  }

  Future<void> updateProfile(UpdateProfileRequest body) async {
    try {
      emit(state.copyWith(updateStatus: LoadStatus.LOADING, error: ''));

      FormData formData = FormData();

      if (body.username != null) {
        formData.fields.add(MapEntry('username', body.username!));
      }
      if (body.fullName != null) {
        formData.fields.add(MapEntry('fullName', body.fullName!));
      }
      if (body.signature != null) {
        formData.fields.add(MapEntry('signature', body.signature!));
      }
      if (body.avatar != null) {
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              body.avatar!.path,
              contentType: MediaType('image', 'png'),
            ),
          ),
        );
      }

      final response = await _userRepository.updateProfile(formData);

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

  Future<void> getUserById(String userId) async {
    try {
      emit(state.copyWith(getUserStatus: LoadStatus.LOADING, error: ''));

      final response = await _userRepository.getUserById(userId);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          getUserStatus: LoadStatus.SUCCESS,
          user: response.data,
          error: '',
        ));
      } else {
        emit(state.copyWith(
          getUserStatus: LoadStatus.FAILURE,
          error: response.error ?? 'Failed to load user',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        getUserStatus: LoadStatus.FAILURE,
        error: 'Failed to load user: ${e.toString()}',
      ));
    }
  }

  Future<void> loadSocialGraph(String userId) async {
    try {
      emit(state.copyWith(getSocialGraphStatus: LoadStatus.LOADING, error: ''));

      final followersResponse = await _userRepository.getFollowers(userId);
      final followingsResponse = await _userRepository.getFollowings(userId);

      if (followersResponse.success &&
          followersResponse.data != null &&
          followingsResponse.success &&
          followingsResponse.data != null) {
        emit(state.copyWith(
          getSocialGraphStatus: LoadStatus.SUCCESS,
          followers: followersResponse.data!.items,
          followings: followingsResponse.data!.items,
          error: '',
        ));
      } else {
        emit(state.copyWith(
          getSocialGraphStatus: LoadStatus.FAILURE,
          error: followersResponse.error ?? 'Failed to load followers',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        getSocialGraphStatus: LoadStatus.FAILURE,
        error: 'Failed to load followers: ${e.toString()}',
      ));
    }
  }

  void clearSocialGraph() {
    emit(state.copyWith(
      followers: null,
      followings: null,
    ));
  }

  Future<void> followUserById(String userId) async {
    try {
      emit(state.copyWith(error: '', followStatus: LoadStatus.LOADING));

      final response = await _userRepository.followUser(userId);

      if (response.success) {
        emit(state.copyWith(
          error: '',
          followStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          error: response.error ?? 'Failed to follow user',
          followStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to follow user: ${e.toString()}',
        followStatus: LoadStatus.FAILURE,
      ));
    }
  }

  Future<void> unfollowUserById(String userId) async {
    try {
      emit(state.copyWith(error: '', followStatus: LoadStatus.LOADING));

      final response = await _userRepository.unfollowUser(userId);

      if (response.success) {
        emit(state.copyWith(
          error: '',
          followStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          error: response.error ?? 'Failed to unfollow user',
          followStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to unfollow user: ${e.toString()}',
        followStatus: LoadStatus.FAILURE,
      ));
    }
  }
}
