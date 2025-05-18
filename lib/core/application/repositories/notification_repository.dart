import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/notification/notification.dart';

abstract class NotificationRepository {
  Future<ObjectResponse<ArrayResponse<Notification>>> getList();
}
