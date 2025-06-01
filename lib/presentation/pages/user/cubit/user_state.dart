part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final String? error;

  final List<UserEntity>? followers;
  final List<UserEntity>? followings;

  final List<Video>? videos;
  final List<Video>? likedVideos;

  final LoadStatus? getUserStatus;
  final LoadStatus? updateStatus;
  final LoadStatus? getSocialGraphStatus;
  final LoadStatus? followStatus;
  final LoadStatus? unfollowStatus;
  final LoadStatus? getListVideoStatus;
  final LoadStatus? getListLikedVideoStatus;

  const UserState({
    this.user,
    this.followers,
    this.followings,
    this.videos,
    this.likedVideos,
    this.error,
    this.updateStatus,
    this.getUserStatus,
    this.getSocialGraphStatus,
    this.followStatus,
    this.unfollowStatus,
    this.getListVideoStatus,
    this.getListLikedVideoStatus,
  });

  UserState copyWith({
    UserEntity? user,
    List<UserEntity>? followers,
    List<UserEntity>? followings,
    List<Video>? videos,
    List<Video>? likedVideos,
    String? error,
    LoadStatus? updateStatus,
    LoadStatus? getUserStatus,
    LoadStatus? getSocialGraphStatus,
    LoadStatus? followStatus,
    LoadStatus? unfollowStatus,
    LoadStatus? getListVideoStatus,
    LoadStatus? getListLikedVideoStatus,
  }) {
    return UserState(
      user: user ?? this.user,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      videos: videos ?? this.videos,
      likedVideos: likedVideos ?? this.likedVideos,
      error: error ?? this.error,
      updateStatus: updateStatus ?? this.updateStatus,
      getUserStatus: getUserStatus ?? this.getUserStatus,
      getSocialGraphStatus: getSocialGraphStatus ?? this.getSocialGraphStatus,
      followStatus: followStatus ?? this.followStatus,
      unfollowStatus: unfollowStatus ?? this.unfollowStatus,
      getListVideoStatus: getListVideoStatus ?? this.getListVideoStatus,
      getListLikedVideoStatus:
          getListLikedVideoStatus ?? this.getListLikedVideoStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        followers,
        followings,
        videos,
        likedVideos,
        error,
        updateStatus,
        getUserStatus,
        getSocialGraphStatus,
        followStatus,
        unfollowStatus,
        getListVideoStatus,
        getListLikedVideoStatus,
      ];
}
