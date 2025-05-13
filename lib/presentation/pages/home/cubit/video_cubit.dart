import 'package:babilon/core/application/models/request/video/create_comment.dart';
import 'package:babilon/core/application/models/response/video/comment.dart';
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

  Future<void> getTrendingVideos({bool? isRefresh}) async {
    try {
      emit(state.copyWith(
        getTrendingVideosStatus: LoadStatus.LOADING,
        videos: isRefresh == true ? [] : state.videos,
      ));
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

  Future<void> getListVideoOfFollowing({bool? isRefresh}) async {
    try {
      emit(state.copyWith(
        getVideoOfFollowingStatus: LoadStatus.LOADING,
        videoOfFollowing: isRefresh == true ? [] : state.videoOfFollowing,
      ));
      final response = await _videoRepository.getListVideoOfFollowing();
      if (response.success && response.data != null) {
        emit(state.copyWith(
          videoOfFollowing: response.data?.items,
          totalVideoOfFollowing: response.data?.total,
          error: '',
          getVideoOfFollowingStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          error: response.error,
          getVideoOfFollowingStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        getVideoOfFollowingStatus: LoadStatus.FAILURE,
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

  Future<void> getCommentsByVideoId(String videoId) async {
    try {
      emit(state.copyWith(
        error: '',
        getCommentsStatus: LoadStatus.LOADING,
      ));
      final response = await _videoRepository.getCommentsByVideoId(videoId);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          comments: response.data?.items,
          commentsTotal: response.data?.total,
          error: '',
          getCommentsStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          error: response.error,
          getCommentsStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        getCommentsStatus: LoadStatus.FAILURE,
      ));
    }
  }

  Future<void> createComment(String videoId, String comment) async {
    try {
      emit(state.copyWith(createCommentStatus: LoadStatus.LOADING));
      final body = CreateComment(comment: comment);
      final response = await _videoRepository.createComment(videoId, body);
      if (response.success) {
        emit(state.copyWith(createCommentStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(createCommentStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(createCommentStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> createView(String videoId) async {
    await _videoRepository.createView(videoId);
  }
}
