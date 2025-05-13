part of 'live_cubit.dart';

class LiveState extends Equatable {
  final List<Live>? liveTrending;
  final String? error;
  final LoadStatus? getLiveTrendingStatus;

  const LiveState({
    this.liveTrending,
    this.error,
    this.getLiveTrendingStatus,
  });

  LiveState copyWith({
    List<Live>? liveTrending,
    String? error,
    LoadStatus? getLiveTrendingStatus,
  }) {
    return LiveState(
      liveTrending: liveTrending ?? this.liveTrending,
      error: error ?? this.error,
      getLiveTrendingStatus:
          getLiveTrendingStatus ?? this.getLiveTrendingStatus,
    );
  }

  @override
  List<Object?> get props => [
        liveTrending,
        error,
        getLiveTrendingStatus,
      ];
}
