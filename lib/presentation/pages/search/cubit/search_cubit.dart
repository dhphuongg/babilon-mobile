import 'package:babilon/core/application/models/response/user/user.entity.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/application/repositories/user_repository.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  VideoRepository _videoRepository;
  UserRepository _userRepository;

  SearchCubit({
    required VideoRepository videoRepository,
    required UserRepository userRepository,
  })  : _videoRepository = videoRepository,
        _userRepository = userRepository,
        super(const SearchState());

  Future<void> searchVideos(String q) async {
    try {
      emit(state.copyWith(getVideosStatus: LoadStatus.LOADING, error: ''));

      final response = await _videoRepository.searchVideos(q);
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            videos: response.data!.items,
            getVideosStatus: LoadStatus.SUCCESS,
          ),
        );
      } else {
        emit(
          state.copyWith(
            getVideosStatus: LoadStatus.FAILURE,
            error: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          getVideosStatus: LoadStatus.FAILURE,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> searchUsers(String q) async {
    try {
      emit(state.copyWith(getUsersStatus: LoadStatus.LOADING, error: ''));

      final response = await _userRepository.searchUsers(q);
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            users: response.data!.items,
            getUsersStatus: LoadStatus.SUCCESS,
          ),
        );
      } else {
        emit(
          state.copyWith(
            getUsersStatus: LoadStatus.FAILURE,
            error: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          getUsersStatus: LoadStatus.FAILURE,
          error: e.toString(),
        ),
      );
    }
  }

  void clearSearchResult() {
    emit(
      state.copyWith(
        videos: [],
        users: [],
        getVideosStatus: LoadStatus.INITIAL,
        getUsersStatus: LoadStatus.INITIAL,
        error: '',
      ),
    );
  }
}
