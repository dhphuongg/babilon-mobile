import 'package:dio/dio.dart';
import 'package:babilon/core/application/models/request/login/login_request.dart';
import 'package:babilon/core/application/models/response/login/login.dart';
import 'package:retrofit/retrofit.dart';

import 'array_response.dart';
import 'object_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST('/TokenAuth/Authenticate')
  Future<ObjectResponse<LoginResponse>> login(
    @Body() LoginRequest body,
  );

  @DELETE('/services/app/Prospect/Delete')
  Future<ObjectResponse<dynamic>> deleteProspect(
    @Query("id") String id,
  );
}
