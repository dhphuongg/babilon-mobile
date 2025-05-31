part of 'post_video_cubit.dart';

class PostVideoState extends Equatable {
  final String? error;
  final LoadStatus? postVideoStatus;
  final Video? postedVideo;

  const PostVideoState({
    this.error,
    this.postVideoStatus,
    this.postedVideo,
  });

  PostVideoState copyWith({
    String? error,
    LoadStatus? postVideoStatus,
    Video? postedVideo,
  }) {
    return PostVideoState(
      error: error ?? this.error,
      postVideoStatus: postVideoStatus ?? this.postVideoStatus,
      postedVideo: postedVideo ?? this.postedVideo,
    );
  }

  List<Object?> get props => [
        error,
        postVideoStatus,
        postedVideo,
      ];
}
