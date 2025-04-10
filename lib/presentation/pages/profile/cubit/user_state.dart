part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final String? error;

  final List<UserPublic>? followers;
  final List<UserPublic>? followings;

  final LoadStatus? getUserStatus;
  final LoadStatus? updateStatus;
  final LoadStatus? getSocialGraphStatus;
  final LoadStatus? followStatus;
  final LoadStatus? unfollowStatus;

  const UserState({
    this.user,
    this.followers,
    this.followings,
    this.error,
    this.updateStatus,
    this.getUserStatus,
    this.getSocialGraphStatus,
    this.followStatus,
    this.unfollowStatus,
  });

  UserState copyWith({
    UserEntity? user,
    List<UserPublic>? followers,
    List<UserPublic>? followings,
    String? error,
    LoadStatus? updateStatus,
    LoadStatus? getUserStatus,
    LoadStatus? getSocialGraphStatus,
    LoadStatus? followStatus,
    LoadStatus? unfollowStatus,
  }) {
    return UserState(
      user: user ?? this.user,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      error: error ?? this.error,
      updateStatus: updateStatus ?? this.updateStatus,
      getUserStatus: getUserStatus ?? this.getUserStatus,
      getSocialGraphStatus: getSocialGraphStatus ?? this.getSocialGraphStatus,
      followStatus: followStatus ?? this.followStatus,
      unfollowStatus: unfollowStatus ?? this.unfollowStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        followers,
        followings,
        error,
        updateStatus,
        getUserStatus,
        getSocialGraphStatus,
        followStatus,
        unfollowStatus,
      ];
}
