import 'package:babilon/core/application/models/response/notification/notification.dart';
import 'package:babilon/core/application/repositories/notification_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationCubit({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        super(const NotificationState());

  Future<void> getNotificationList() async {
    try {
      emit(state.copyWith(
        getNotificationListStatus: LoadStatus.LOADING,
        error: '',
      ));

      final response = await _notificationRepository.getList();

      if (response.success && response.data != null) {
        emit(state.copyWith(
          getNotificationListStatus: LoadStatus.SUCCESS,
          notifications: response.data!.items,
        ));
      } else {
        emit(state.copyWith(
          error: response.error,
          getNotificationListStatus: LoadStatus.FAILURE,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        getNotificationListStatus: LoadStatus.FAILURE,
      ));
    }
  }
}
