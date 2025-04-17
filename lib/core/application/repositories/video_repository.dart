import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/video/video.dart';

abstract class VideoRepository {
  Future<ObjectResponse<ArrayResponse<Video>>> getTrendingVideos();

  Future<ObjectResponse> likeVideoById(String videoId);

  Future<ObjectResponse> unlikeVideoById(String videoId);
}
