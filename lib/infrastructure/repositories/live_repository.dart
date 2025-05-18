import 'package:babilon/core/application/api/array_response.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/application/models/response/live/live.dart';
import 'package:babilon/core/application/repositories/live_repository.dart';
import 'package:babilon/core/domain/resources/client_provider.dart';

class LiveRepositoryImpl implements LiveRepository {
  @override
  Future<ObjectResponse<ArrayResponse<Live>>> getLiveTrending() {
    return RestClientProvider.apiClient!.getLiveTrending();
  }

  @override
  Future<ObjectResponse<Live>> getByUserId(String userId) {
    return RestClientProvider.apiClient!.getLiveByUserId(userId);
  }
}
