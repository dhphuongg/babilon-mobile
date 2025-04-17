import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/video/video.dart';
import 'package:babilon/core/application/repositories/video_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class VideoRepositoryImpl implements VideoRepository {
  @override
  Future<ObjectResponse<ArrayResponse<Video>>> getTrendingVideos() {
    return RestClientProvider.apiClient!.getTrendingVideos();
  }

  @override
  Future<ObjectResponse> likeVideoById(String videoId) {
    return RestClientProvider.apiClient!.likeVideoById(videoId);
  }

  @override
  Future<ObjectResponse> unlikeVideoById(String videoId) {
    return RestClientProvider.apiClient!.unlikeVideoById(videoId);
  }
}
