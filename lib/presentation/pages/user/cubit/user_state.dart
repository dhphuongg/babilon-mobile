part of 'user_cubit.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  final LoadStatus? getProfileStatus;
  final LoadStatus? updateStatus;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error,
    this.updateStatus,
    this.getProfileStatus,
  });

  UserState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    LoadStatus? updateStatus,
    LoadStatus? getProfileStatus,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      updateStatus: updateStatus ?? this.updateStatus,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isLoading,
        error,
        updateStatus,
        getProfileStatus,
      ];
}
