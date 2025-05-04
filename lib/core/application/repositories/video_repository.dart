import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/request/video/create_comment.dart';
import 'package:babilon/core/application/models/response/video/comment.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:dio/dio.dart';

abstract class VideoRepository {
  Future<ObjectResponse> postVideo(FormData body);

  Future<ObjectResponse<ArrayResponse<Video>>> getMyListVideo();

  Future<ObjectResponse<ArrayResponse<Video>>> getListVideoByUserId(
    String userId,
  );

  Future<ObjectResponse<ArrayResponse<Video>>> getTrendingVideos();

  Future<ObjectResponse> likeVideoById(String videoId);

  Future<ObjectResponse> unlikeVideoById(String videoId);

  Future<ObjectResponse<ArrayResponse<Comment>>> getCommentsByVideoId(
    String videoId,
  );

  Future createComment(String videoId, CreateComment body);

  Future createView(String videoId);
}
