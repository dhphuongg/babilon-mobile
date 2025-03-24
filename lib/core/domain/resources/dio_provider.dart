import 'dart:convert';
import 'dart:io';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/domain/utils/navigation_services.dart';
import 'package:babilon/core/domain/utils/share_preferrences.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:babilon/sql_lite.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:babilon/core/domain/storages/global_storages.dart';
import 'package:babilon/core/domain/utils/check_connection_util.dart';
import 'package:babilon/core/domain/utils/logger.dart';
import 'package:babilon/core/domain/utils/utils.dart';
import 'package:flutter/material.dart';

Future<Dio> provideDio(
    {Map<String, dynamic>? pHeaders, bool isNewVersion = false}) async {
  // Try to get access token. If existing, add this token to the http headers
  final Map<String, dynamic> headers =
      pHeaders ?? {'content-type': 'application/json'};
  String accessToken = await getAccessToken();

  if (accessToken.isNotEmpty) {
    headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
  }

  final BaseOptions options = BaseOptions(
    headers: headers,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
    validateStatus: (status) {
      // Allow all status codes to pass without throwing DioError
      return true; // Always return true to avoid DioError
    },
  );

  final Dio dio = Dio(options);
  //TO DO :by pass certificate
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  //-------------------------
  final InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
    onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      final bool isNetworkAvailable = await checkInternetConnection();
      GlobalStorage.hasInternetConnect = isNetworkAvailable;

      if (!isNetworkAvailable && !Platform.isWindows) {
        // Không có mạng, load response từ cache
        var cachedData = await loadCachedResponse(options.uri.toString());

        if (cachedData != null) {
          // Tạo response từ cache và gọi onResponse
          return handler.resolve(Response(
            requestOptions: options,
            data: cachedData, // Dữ liệu lấy từ cache (chuỗi JSON hoặc bất kỳ)
            statusCode: 200, // Đặt mã trạng thái tùy thích (ví dụ 200)
            statusMessage: 'Offline data loaded',
          ));
        } else {
          // Không có dữ liệu cache, gọi onError
          return handler.reject(DioError(
            requestOptions: options,
            error: 'No internet and no cached data',
            type: DioErrorType.other,
          ));
        }
      }

      // Có mạng, tiếp tục gửi request bình thường
      return handler.next(options);
    },
    onResponse: (
      Response response,
      ResponseInterceptorHandler responseInterceptorHandler,
    ) async {
      final bool isNetworkAvailable = await checkInternetConnection();

      if (kReleaseMode) {
        AppLogger.instance.debug(response.toString());
      }
      if (isNetworkAvailable && !Platform.isWindows)
        await saveResponseToCache(response);

      if (response.statusCode == 401) {
        await SharedPreferencesHelper.removeByKey(
            SharedPreferencesHelper.ACCESS_TOKEN);
        await SharedPreferencesHelper.removeByKey(
            SharedPreferencesHelper.REFRESH_TOKEN);

        Navigator.pushNamedAndRemoveUntil(
          NavigationService.navigatorKey.currentContext!,
          RouteName.login,
          (Route<dynamic> route) => false,
        );
      }

      return responseInterceptorHandler.next(response);
    },
    onError: customHandleErrorByStatusCode,
  );
  dio.interceptors.add(interceptorsWrapper);

  return dio;
}

customHandleErrorByStatusCode(
  DioError e,
  ErrorInterceptorHandler handler,
) async {
  if (e.type == DioErrorType.cancel) {
    // Suppress this type of error, clear and move next
    e.error = "";
    return;
  }
  if (e.error is SocketException) {
    // e.error = "Không thể kết nối tới server";
    e.error = "";
    return handler.next(e);
  }
  return handler.next(e);
}

Future<void> saveResponseToCache(Response response) async {
  if (response.requestOptions.method.toUpperCase() == 'GET') {
    // Lấy URL đầy đủ bao gồm cả query
    String url = response.requestOptions.uri.toString();

    // Chuyển đổi response thành chuỗi JSON
    String responseData = jsonEncode(response.data);

    // Lưu vào database
    await CacheDatabase.saveResponse(url, responseData);
  }
}

Future<Map<String, dynamic>?> loadCachedResponse(String url) async {
  String? cachedData = await CacheDatabase.loadResponse(url);

  if (cachedData != null) {
    // Chuyển đổi chuỗi JSON thành Map trước khi trả về
    return jsonDecode(cachedData) as Map<String, dynamic>;
  }

  return null; // Không có dữ liệu
}

// void showPopUpNetworkError() {
//   showCustomDialog(
//     NavigationService.navigatorKey.currentContext!,
//     hideNegativeButton: true,
//     onPressPositive: () async {
//       final bool isNetworkAvailable = await checkConnection();
//       if (isNetworkAvailable) {
//         final globalContext = NavigationService.navigatorKey.currentContext!;
//         Navigator.of(globalContext).pop();
//         GlobalStorage.haveDialogError = false;
//       }
//     },
//     title: 'No internet connection!',
//     content: Text(
//       'Không có kết nối',
//       textAlign: TextAlign.center,
//       style: AppStyle.regular14black,
//     ),
//     textPositive: 'Retry',
//     barrierDismissible: false,
//     preventBack: true,
//   );
// }
