import 'package:babilon/core/application/models/response/live/live.dart';
import 'package:babilon/core/application/repositories/live_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  final LiveRepository _liveRepository;

  LiveCubit({
    required LiveRepository liveRepository,
  })  : _liveRepository = liveRepository,
        super(const LiveState());

  Future<void> getLiveTrending() async {
    try {
      emit(
          state.copyWith(getLiveTrendingStatus: LoadStatus.LOADING, error: ''));

      final response = await _liveRepository.getLiveTrending();
      if (response.success && response.data != null) {
        emit(
          state.copyWith(
            getLiveTrendingStatus: LoadStatus.SUCCESS,
            liveTrending: response.data!.items,
          ),
        );
      } else {
        emit(
          state.copyWith(
            getLiveTrendingStatus: LoadStatus.FAILURE,
            error: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          getLiveTrendingStatus: LoadStatus.FAILURE,
          error: e.toString(),
        ),
      );
    }
  }
}
