part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserEntity? userProfile;
  final bool? isVideoPlaying;

  const AppState({
    this.userProfile,
    this.isVideoPlaying,
  });

  AppState copyWith({
    UserEntity? userProfile,
    bool? isVideoPlaying,
  }) {
    return AppState(
      userProfile: userProfile ?? this.userProfile,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        isVideoPlaying,
      ];
}
