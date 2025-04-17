import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepository _videoRepository;

  VideoCubit({required VideoRepository videoRepository})
      : _videoRepository = videoRepository,
        super(const VideoState());

  Future<void> getTrendingVideos() async {
    try {
      emit(state.copyWith(getTrendingVideosStatus: LoadStatus.LOADING));
      final response = await _videoRepository.getTrendingVideos();
      if (response.success && response.data != null) {
        emit(state.copyWith(
          videos: response.data?.items,
          total: response.data?.total,
          error: '',
          getTrendingVideosStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          error: response.error,
          getTrendingVideosStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        getTrendingVideosStatus: LoadStatus.FAILURE,
      ));
    }
  }

  Future<void> likeVideoById(String videoId) async {
    try {
      emit(state.copyWith(likeVideoStatus: LoadStatus.LOADING));
      final response = await _videoRepository.likeVideoById(videoId);
      if (response.success) {
        emit(state.copyWith(likeVideoStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(likeVideoStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(likeVideoStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> unlikeVideoById(String videoId) async {
    try {
      emit(state.copyWith(unlikeVideoStatus: LoadStatus.LOADING));
      final response = await _videoRepository.unlikeVideoById(videoId);
      if (response.success) {
        emit(state.copyWith(unlikeVideoStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(unlikeVideoStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(unlikeVideoStatus: LoadStatus.FAILURE));
    }
  }
}
