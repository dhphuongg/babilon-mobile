import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/notification/notification.dart';
import 'package:babilon/core/application/repositories/notification_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<ObjectResponse<ArrayResponse<Notification>>> getList() {
    return RestClientProvider.apiClient!.getNotificationList();
  }
}
