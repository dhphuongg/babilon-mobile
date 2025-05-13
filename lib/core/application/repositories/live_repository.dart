import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/live/live.dart';

abstract class LiveRepository {
  Future<ObjectResponse<ArrayResponse<Live>>> getLiveTrending();
}
