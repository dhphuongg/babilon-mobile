import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/video/create_comment.dart';
import 'package:babilon/core/application/models/response/video/comment.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';
import 'package:dio/src/form_data.dart';

class VideoRepositoryImpl implements VideoRepository {
  @override
  Future<ObjectResponse<Video>> postVideo(FormData body) {
    return RestClientProvider.apiClient!.postVideo(body);
  }

  @override
  Future<ObjectResponse<ArrayResponse<Video>>> getMyListVideo() {
    return RestClientProvider.apiClient!.getMyListVideo();
  }

  @override
  Future<ObjectResponse<ArrayResponse<Video>>> getListVideoByUserId(
    String userId,
  ) {
    return RestClientProvider.apiClient!.getListVideoByUserId(userId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<Video>>> getTrendingVideos() {
    return RestClientProvider.apiClient!.getTrendingVideos();
  }

  @override
  Future<ObjectResponse<ArrayResponse<Video>>> getListVideoOfFollowing() {
    return RestClientProvider.apiClient!.getListVideoOfFollowing();
  }

  @override
  Future<ObjectResponse> likeVideoById(String videoId) {
    return RestClientProvider.apiClient!.likeVideoById(videoId);
  }

  @override
  Future<ObjectResponse> unlikeVideoById(String videoId) {
    return RestClientProvider.apiClient!.unlikeVideoById(videoId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<Comment>>> getCommentsByVideoId(
    String videoId,
  ) {
    return RestClientProvider.apiClient!.getCommentsByVideoId(videoId);
  }

  @override
  Future createComment(String videoId, CreateComment body) {
    return RestClientProvider.apiClient!.createComment(videoId, body);
  }

  @override
  Future createView(String videoId) {
    return RestClientProvider.apiClient!.createView(videoId);
  }

  @override
  Future<ObjectResponse<ArrayResponse<Video>>> searchVideos(String query) {
    return RestClientProvider.apiClient!.searchVideos(query);
  }
}
