import 'package:dio/dio.dart';
import 'package:babilon/core/application/api/api_client.dart';
import 'package:babilon/core/domain/resources/dio_provider.dart';
import '../constants/api.dart';

class RestClientProvider {
  static ApiClient? apiClient;

  // static final String _baseUrl = env['BASE_URL'];

  /// Initialize rest client.
  /// [dio] The dio that will be used as a http client
  /// [forceInit] If true, we recreate RestClient. This is necessary when user
  /// logs in successfully or the token is reset/refreshed. In that case, we need to set
  /// the token to header again.
  static Future<void> init(
      {Dio? dio, String? baseUrl, bool forceInit = false}) async {
    Dio? apiProvidedDio = dio;

    // If dio is not passed, generate new one
    apiProvidedDio ??= await provideDio();

    final String _baseUrl = '${baseUrl ?? Api.baseUrl}/api/v1';

    if (forceInit) {
      apiClient = ApiClient(apiProvidedDio, baseUrl: _baseUrl);
    } else {
      // Only recreate when restClient is null.
      apiClient ??= ApiClient(apiProvidedDio, baseUrl: _baseUrl);
    }
  }
}
