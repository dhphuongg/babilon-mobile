part of 'user_cubit.dart';

class UserState extends Equatable {
  final String? avatarUrl;
  final String fullName;
  final String username;
  final String? signature;
  final int followingCount;
  final int followersCount;
  final bool isLoading;
  final String? error;

  const UserState({
    this.avatarUrl,
    this.fullName = '',
    this.username = '',
    this.signature = '',
    this.followingCount = 0,
    this.followersCount = 0,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    String? avatarUrl,
    String? fullName,
    String? username,
    String? signature,
    int? followingCount,
    int? followersCount,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      signature: signature ?? this.signature,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        avatarUrl,
        fullName,
        username,
        signature,
        followingCount,
        followersCount,
        isLoading,
        error,
      ];
}
