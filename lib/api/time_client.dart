import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import 'client.dart';

class TimeClient {
  Dio dio = Dio();
  
  TimeClient() {
    dio.options.baseUrl = "http://worldtimeapi.org/api/";
    dio.options.headers["Accept"] = "application/json";
    // dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    // dio.options.headers['Access-Control-Allow-Origin'] = '*';
    // dio.options.headers['Access-Control-Allow-Methods'] = ['GET, POST'];
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
        // handler.next(err);
      },
    ));
  }

  Future<DateTime> getTime() async {
    Response response = await dio.get("/timezone/Etc/UTC");
    return DateTime.parse(response.data["datetime"]);
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
        break;
    }
    return error;
  }
}