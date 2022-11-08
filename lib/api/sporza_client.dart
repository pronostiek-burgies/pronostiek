import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as get_x;
import 'package:pronostiek/models/match.dart';

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();

class SporzaClient {
  Dio dio = Dio();
  final String apiKey = "c828d180-4742-11ed-9ed9-69bf0197c789";
  final seasonIdWC = "3072";
  final seasonIdjpl = "3133";

  static const editionIds = {
    "LaLiga": 26112,
    "jpl": 26093,
    "bundesliga": 2696,
  };


  SporzaClient() {
    dio.options.baseUrl = "https://thingproxy.freeboard.io/fetch/https://api.sporza.be/soccer/";
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 5000;
    dio.options.contentType = "application/x-www-form-urlencoded";
    // dio.options["origin"] = "test";
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

  Future<Map<String,dynamic>?> getMatch(int? matchId) async {
    Response response;
    if (matchId == null) {return null;}
    try {
      response = await dio.get("matches/$matchId");
    } catch (e) {
      return null;
    }
    return Map<String,dynamic>.from(response.data);
  }

  static Map<String,dynamic> mapToOurInterface(Map<String,dynamic> data) {
    if (data["endedAfter"] != "REGULARTIME") {
      return {};
    }
    return {
      "id": data["id"],
      "status": {"END": MatchStatus.ended.index, "NOT_STARTED": MatchStatus.notStarted.index}[data["status"]],
      "time": data["liveTime"],
      "goals_Home_FT": data["homeScore"],
      "goals_Away_FT": data["awayScore"],
      "goals_Home_Pen": data["shootoutHomeScore"],
      "goals_Away_Pen": data["shootoutAwayScore"],
    };
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
