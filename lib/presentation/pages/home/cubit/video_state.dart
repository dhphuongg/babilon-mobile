part of 'video_cubit.dart';

class VideoState extends Equatable {
  final List<Video>? videos;
  final int total;
  final String? error;
  final LoadStatus? getTrendingVideosStatus;
  final LoadStatus? likeVideoStatus;
  final LoadStatus? unlikeVideoStatus;

  const VideoState({
    this.videos,
    this.total = 0,
    this.error,
    this.getTrendingVideosStatus,
    this.likeVideoStatus,
    this.unlikeVideoStatus,
  });

  VideoState copyWith({
    List<Video>? videos,
    int? total,
    String? error,
    LoadStatus? getTrendingVideosStatus,
    LoadStatus? likeVideoStatus,
    LoadStatus? unlikeVideoStatus,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      total: total ?? this.total,
      error: error ?? this.error,
      getTrendingVideosStatus:
          getTrendingVideosStatus ?? this.getTrendingVideosStatus,
      likeVideoStatus: likeVideoStatus ?? this.likeVideoStatus,
      unlikeVideoStatus: unlikeVideoStatus ?? this.unlikeVideoStatus,
    );
  }

  @override
  List<Object?> get props => [
        videos,
        total,
        error,
        getTrendingVideosStatus,
        likeVideoStatus,
        unlikeVideoStatus,
      ];
}
