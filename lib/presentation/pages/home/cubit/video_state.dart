part of 'video_cubit.dart';

class VideoState extends Equatable {
  final List<Video>? videos;
  final int total;
  final String? error;
  final LoadStatus? getTrendingVideosStatus;

  const VideoState({
    this.videos,
    this.total = 0,
    this.error,
    this.getTrendingVideosStatus,
  });

  VideoState copyWith({
    List<Video>? videos,
    int? total,
    String? error,
    LoadStatus? getTrendingVideosStatus,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      total: total ?? this.total,
      error: error ?? this.error,
      getTrendingVideosStatus:
          getTrendingVideosStatus ?? this.getTrendingVideosStatus,
    );
  }

  @override
  List<Object?> get props => [
        videos,
        total,
        error,
        getTrendingVideosStatus,
      ];
}
