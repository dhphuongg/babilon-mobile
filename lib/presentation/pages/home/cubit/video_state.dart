part of 'video_cubit.dart';

class VideoState extends Equatable {
  final List<Video>? videos;
  final int total;
  final List<Comment>? comments;
  final int commentsTotal;
  final String? error;
  final LoadStatus? getTrendingVideosStatus;
  final LoadStatus? likeVideoStatus;
  final LoadStatus? unlikeVideoStatus;
  final LoadStatus? getCommentsStatus;
  final LoadStatus? createCommentStatus;

  const VideoState({
    this.videos,
    this.total = 0,
    this.comments,
    this.commentsTotal = 0,
    this.error,
    this.getTrendingVideosStatus,
    this.likeVideoStatus,
    this.unlikeVideoStatus,
    this.getCommentsStatus,
    this.createCommentStatus,
  });

  VideoState copyWith({
    List<Video>? videos,
    int? total,
    List<Comment>? comments,
    int? commentsTotal,
    String? error,
    LoadStatus? getTrendingVideosStatus,
    LoadStatus? likeVideoStatus,
    LoadStatus? unlikeVideoStatus,
    LoadStatus? getCommentsStatus,
    LoadStatus? createCommentStatus,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      total: total ?? this.total,
      comments: comments ?? this.comments,
      commentsTotal: commentsTotal ?? this.commentsTotal,
      error: error ?? this.error,
      getTrendingVideosStatus:
          getTrendingVideosStatus ?? this.getTrendingVideosStatus,
      likeVideoStatus: likeVideoStatus ?? this.likeVideoStatus,
      unlikeVideoStatus: unlikeVideoStatus ?? this.unlikeVideoStatus,
      getCommentsStatus: getCommentsStatus ?? this.getCommentsStatus,
      createCommentStatus: createCommentStatus ?? this.createCommentStatus,
    );
  }

  @override
  List<Object?> get props => [
        videos,
        total,
        comments,
        commentsTotal,
        error,
        getTrendingVideosStatus,
        likeVideoStatus,
        unlikeVideoStatus,
        getCommentsStatus,
        createCommentStatus,
      ];
}
