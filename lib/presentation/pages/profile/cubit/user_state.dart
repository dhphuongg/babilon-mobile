part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final String? error;

  final List<UserPublic>? followers;
  final List<UserPublic>? followings;

  final LoadStatus? getProfileStatus;
  final LoadStatus? updateStatus;
  final LoadStatus? getSocialGraphStatus;

  const UserState({
    this.user,
    this.followers,
    this.followings,
    this.error,
    this.updateStatus,
    this.getProfileStatus,
    this.getSocialGraphStatus,
  });

  UserState copyWith({
    UserEntity? user,
    List<UserPublic>? followers,
    List<UserPublic>? followings,
    String? error,
    LoadStatus? updateStatus,
    LoadStatus? getProfileStatus,
    LoadStatus? getSocialGraphStatus,
  }) {
    return UserState(
      user: user ?? this.user,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      error: error ?? this.error,
      updateStatus: updateStatus ?? this.updateStatus,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
      getSocialGraphStatus: getSocialGraphStatus ?? this.getSocialGraphStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        followers,
        followings,
        error,
        updateStatus,
        getProfileStatus,
        getSocialGraphStatus,
      ];
}
