import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as getX;

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();

/// Returns a DioClient with the correct settings and error handling to communicate with the dropbox
Future<Dio> dropboxClient() async {
  Dio dio = Dio();

  // Set default configs
  dio.options.baseUrl = "https://content.dropboxapi.com/2/";
  dio.options.headers["Authorization"] = "Bearer sl.BQ0OOHyGqTulQcqbDpaDwDAHpN1NZsRga6-dGwAbKMmRUeSOyLv5Lugq_7GTSCNUix1gfAmoCKvp9rChgyb62Xry93hMO07pUdZsnaElzzW7R6Iky_X7iWrQkc1uTPOGh205D_0";
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
