part of 'post_video_cubit.dart';

class PostVideoState extends Equatable {
  final String? error;
  final LoadStatus? postVideoStatus;

  const PostVideoState({
    this.error,
    this.postVideoStatus,
  });

  PostVideoState copyWith({
    String? error,
    LoadStatus? postVideoStatus,
  }) {
    return PostVideoState(
      error: error ?? this.error,
      postVideoStatus: postVideoStatus ?? this.postVideoStatus,
    );
  }

  List<Object?> get props => [
        error,
        postVideoStatus,
      ];
}
