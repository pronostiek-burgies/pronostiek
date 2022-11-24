import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as get_x;
import 'package:universal_html/html.dart';

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();


class WebStorage {

  //Singleton
  WebStorage._internal();
  static final WebStorage instance = WebStorage._internal();
  factory WebStorage() {
    return instance;
  }

  String? get username => window.localStorage['username'];
  set username(String? sid) => sid == null ? window.localStorage.remove('username') : window.localStorage['username'] = sid;

  String? get pronostieks => window.localStorage['pronostieks'];
  set pronostieks(String? sid) => sid == null ? window.localStorage.remove('pronostieks') : window.localStorage['pronostieks'] = sid;

  String? get randomSolution => window.localStorage['random_solution'];
  set randomSolution(String? sid) => sid == null ? window.localStorage.remove('random_solution') : window.localStorage['random_solution'] = sid;
  
  String? get randomQuestions => window.localStorage['random_questions'];
  set randomQuestions(String? sid) => sid == null ? window.localStorage.remove('random_questions') : window.localStorage['random_questions'] = sid;
  
  String? get usernames => window.localStorage['usernames'];
  set usernames(String? sid) => sid == null ? window.localStorage.remove('usernames') : window.localStorage['usernames'] = sid;
  
  String? get users => window.localStorage['users'];
  set users(String? sid) => sid == null ? window.localStorage.remove('users') : window.localStorage['users'] = sid;
  
  String? get profileColors => window.localStorage['profile_colors'];
  set profileColors(String? sid) => sid == null ? window.localStorage.remove('profile_colors') : window.localStorage['profile_colors'] = sid;
}

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
      get_x.Get.defaultDialog(
          title: "Connection timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    /// It occurs when url is sent timeout.
    case DioErrorType.sendTimeout:
      get_x.Get.defaultDialog(
          title: "Send timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    ///It occurs when receiving timeout.
    case DioErrorType.receiveTimeout:
      get_x.Get.defaultDialog(
          title: "Receive timeout",
          middleText: "Make sure that you have a working internet connection.");
      break;

    default:
      get_x.Get.defaultDialog(
          title: "Could not connect to the server",
          middleText: "Make sure that you have a working internet connection.");
      break;
  }
  return error;
}
