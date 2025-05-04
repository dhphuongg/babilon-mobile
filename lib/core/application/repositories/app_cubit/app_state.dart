part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserEntity? userProfile;

  const AppState({
    this.userProfile,
  });

  AppState copyWith({
    UserEntity? userProfile,
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
