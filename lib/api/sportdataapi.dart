import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as get_x;

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();

class SportDataApiClient {
  Dio dio = Dio();
  final String apiKey = "c828d180-4742-11ed-9ed9-69bf0197c789";
  final seasonIdWC = "3072";
  final seasonIdjpl = "3133";


  SportDataApiClient() {
    dio.options.baseUrl = "https://app.sportdataapi.com/api/v1/";
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 5000;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        requestInterceptors(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        // responseInterceptors(response);
        handler.next(response);
      },
      onError: (err, handler) {
        errorInterceptors(err);
        handler.next(err);
      },
    ));
  }

  Future<int?> getStatus() async {
    Response response = await dio.get("/status", queryParameters: {"apikey": apiKey});
    return int.tryParse(response.data["remaining_requests"]);
  }

  Future<Map<String,dynamic>> getMatches(DateTime day, {bool wc = true}) async {
    Response response = await dio.get("/soccer/matches", queryParameters: {
      "apikey": apiKey,
      "season_id" : wc ? seasonIdWC : seasonIdjpl,
      "date_from" : DateFormat("y-M-d").format(day),
      "date_to" : DateFormat("y-M-d").format(day.add(Duration(days: 1))),
      });
    return Map<String,dynamic>.from(response.data);
  }



}

requestInterceptors(RequestOptions options) {
  logger.d("${options.method}: ${options.uri}\n${options.data}");
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
