part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<Video>? videos;
  final List<UserEntity>? users;

  final String? error;
  final LoadStatus? getVideosStatus;
  final LoadStatus? getUsersStatus;

  const SearchState({
    this.videos,
    this.users,
    this.error,
    this.getVideosStatus,
    this.getUsersStatus,
  });

  SearchState copyWith({
    List<Video>? videos,
    List<UserEntity>? users,
    String? error,
    LoadStatus? getVideosStatus,
    LoadStatus? getUsersStatus,
  }) {
    return SearchState(
      videos: videos ?? this.videos,
      users: users ?? this.users,
      error: error ?? this.error,
      getVideosStatus: getVideosStatus ?? this.getVideosStatus,
      getUsersStatus: getUsersStatus ?? this.getUsersStatus,
    );
  }

  @override
  List<Object?> get props => [
        videos,
        users,
        error,
        getVideosStatus,
        getUsersStatus,
      ];
}
