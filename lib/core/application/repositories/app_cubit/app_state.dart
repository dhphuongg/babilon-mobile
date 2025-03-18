part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserProfile? userProfile;

  const AppState({
    this.userProfile,
  });

  AppState copyWith({
    UserProfile? userProfile,
  }) {
    return AppState(
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
      ];
}
