import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'client.dart';

class TimeClient {
  Dio dio = Dio();
  
  TimeClient() {
    dio.options.baseUrl = "https://www.timeapi.io/api/Time/current";
    dio.options.headers['accept'] = 'application/json';
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
  }

  Future<DateTime> getTime() async {
    Response response = await dio.get("/zone", queryParameters: {"timeZone": "Europe/Amsterdam"});
    return DateTime(
      response.data["year"],
      response.data["month"],
      response.data["day"],
      response.data["hour"],
      response.data["minute"],
      response.data["seconds"],
      response.data["milliSeconds"]
    );
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
}