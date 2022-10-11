import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as getX;

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();

class DropboxClient {
  Dio dio = Dio();
  Dio authClient;
  String accessToken = "sl.BQ7xFLs5siV8vEpMnLlJrE6_ktnkIyoT_H51KMGa6PGCmHxA9N2m1noBLIaB126pbSWknqQYU5ZY1vhhugEHbZEljVQ3WDzTIIFz_U937ZYsor1u7zsmDzLK8kp4ZePSeU_V-2g";
  final String refreshToken = "CeNyQGQj18EAAAAAAAAAAezlTCKIxBz-mjuixARcq2O9z2fvMsudhK4xVOLHvURe";

  DropboxClient(this.authClient) {
    dio.options.baseUrl = "https://content.dropboxapi.com/2/";
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 5000;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        requestInterceptors(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        responseInterceptors(response);
        handler.next(response);
      },
      onError: (err, handler) {
        errorTokenExpiredInterceptor(err);
        errorInterceptors(err);
        handler.next(err);
      },
    ));
  }

  errorTokenExpiredInterceptor(DioError error) async {
    if (error.type == DioErrorType.response) {
      if (error.response!.statusCode == 401) {
        await refreshAccessToken();
      }
    }
  }

  Future<void> refreshAccessToken() async {
    Response response = await authClient.post("/oauth2/token", data: {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
    });
    dio.options.headers["Authorization"] = "Bearer ${response.data["access_token"]}";
  }

}

Future<Dio> dropboxAuthClient() async {
  Dio dio = Dio();
  String appKey = "rl5hbzehmfwp85w";
  String appSecret = "3419vcnk49gjmzi";

  // Set default configs
  dio.options.baseUrl = "https://api.dropbox.com";
  dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
  dio.options.headers["Authorization"] = 'Basic ${base64Encode(utf8.encode('$appKey:$appSecret'))}';
  dio.options.connectTimeout = 10000; //10s
  dio.options.receiveTimeout = 5000;
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      requestInterceptors(options);
      handler.next(options);
    },
    onResponse: (response, handler) {
      responseInterceptors(response);
      handler.next(response);
    },
    onError: (err, handler) {
      errorInterceptors(err);
      handler.next(err);
    },
  ));
  return dio;
}

requestInterceptors(RequestOptions options) {
  logger.d("${options.method}: ${options.uri}\n${options.headers["Dropbox-API-Arg"]}\n${options.data}");
  return options;
}

responseInterceptors(Response response) {
  logger.d(response.data);
  return response;
}

errorInterceptors(DioError error) {
  logger.d("${error.error}\n${error.type}\n${error.response}");
  switch (error.type) {

    /// It occurs when url is opened timeout.
    case DioErrorType.connectTimeout:
      getX.Get.defaultDialog(
          title: "Connection timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    /// It occurs when url is sent timeout.
    case DioErrorType.sendTimeout:
      getX.Get.defaultDialog(
          title: "Send timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    ///It occurs when receiving timeout.
    case DioErrorType.receiveTimeout:
      getX.Get.defaultDialog(
          title: "Receive timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    default:
      break;
  }
  return error;
}
