import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart' as get_x;
import 'package:pronostiek/models/match.dart';

// Logger logger = Logger(level: Level.nothing);
Logger logger = Logger();

class SporzaClient {
  Dio dio = Dio();
  Dio secondDio = Dio();

  static const editionIds = {
    "LaLiga": 26112,
    "jpl": 26093,
    "bundesliga": 2696,
  };


  SporzaClient() {
    if (kIsWeb) {
      dio.options.baseUrl = "https://corsproxy.io/?https://api.sporza.be/web/soccer/";
    } else {
      dio.options.baseUrl = "https://api.sporza.be/soccer/";
    }
    dio.options.connectTimeout = 10000; //10s
    dio.options.receiveTimeout = 5000;
    dio.options.contentType = "application/x-www-form-urlencoded";

    secondDio.options.baseUrl = "https://v3.football.api-sports.io/";
    secondDio.options.connectTimeout = 10000; //10s
    secondDio.options.receiveTimeout = 5000;
    secondDio.options.headers["x-rapidapi-key"] = "523352661f9a00afc9774f715f491d21";
    secondDio.options.headers["x-rapidapi-host"] = "v3.football.api-sports.io";

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
        // errorInterceptors(err);
        handler.next(err);
      },
    ));
    secondDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        requestInterceptors(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        // responseInterceptors(response);
        handler.next(response);
      },
      onError: (err, handler) {
        // errorInterceptors(err);
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
      return Future.delayed(const Duration(seconds: 2), () => getMatch(matchId));
    }
    return Map<String,dynamic>.from(response.data);
  }

  Future<List<int?>> getFTScore(int? matchId) async {
    Response response;
    if (matchId == null) {return [null, null];}
    try {
      response = await secondDio.get("fixtures", queryParameters: {"id": matchId});
    } catch (e) {
      return [null, null];
    }
    int? home = response.data["response"][0]["score"]["fulltime"]["home"];
    int? away = response.data["response"][0]["score"]["fulltime"]["away"];
    return [home, away];
  }


  static List<int?> _parseLiveTime(String? liveTime) {
    if (liveTime == null) {return [null, null];}
    if (liveTime.contains("+")) {
      List<String> time = liveTime.substring(0, liveTime.length-1).split("+");
      return time.map((e) => int.tryParse(e)).toList();
    } else {
      return [int.tryParse(liveTime.substring(0, liveTime.length-1)), null];
    }
  }

  

  Future<Map<String,dynamic>> mapToOurInterface(Map<String,dynamic> data, Match match) async {
    Map<String,dynamic> re = {};
    re["id"] = match.id;
    re["status"] = {
      "END": MatchStatus.ended.name,
      "NOT_STARTED": MatchStatus.notStarted.name,
      "LIVE": MatchStatus.inPlay.name
      }[data["status"]] ?? MatchStatus.notStarted.name;
    List<int?> time = _parseLiveTime(data["liveTime"]);
    data["time"] = time[0];
    data["extra_time"] = time[1];
    if (data["status"] == "LIVE") {
      re["live_status"] = {
        "FIRST_HALF": LiveMatchStatus.regularTime.name,
        "SECOND_HALF": LiveMatchStatus.regularTime.name,
        "HALF_TIME": LiveMatchStatus.halfTime.name,
        "FIRST_EXTRA_TIME": LiveMatchStatus.overTime,
        "SECOND_EXTRA_TIME": LiveMatchStatus.overTime,
        "PENALTY_SHOOTOUT": LiveMatchStatus.penalties,
        "UNKNOWN": LiveMatchStatus.unknown,
      }[data["liveMatchPhase"]];
    } else {
      re["live_status"] = null;
    }

    if (!match.knockout) {
      re["goals_Home_FT"] = data["homeScore"];
      re["goals_Away_FT"] = data["awayScore"];
    } else {
      if (data["endedAfter"] == "REGULARTIME") {
        re["goals_Home_FT"] = data["homeScore"];
        re["goals_Away_FT"] = data["awayScore"];
      } else {
        if (match.scoreFTChecked) {
          re["goals_Home_FT"] = match.goalsHomeFT;
          re["goals_Away_FT"] = match.goalsAwayFT;
          re["goals_Home_OT"] = match.goalsHomeOT;
          re["goals_Away_OT"] = match.goalsAwayOT;
        } else {
          List<int?> scoreFT = await getFTScore(match.apiSports);
          if (scoreFT[0] != null && scoreFT[1] != null) {
            re["score_FT_checked"] = true;
            re["goals_Home_FT"] = scoreFT[0];
            re["goals_Away_FT"] = scoreFT[1];
            re["goals_Home_OT"] = data["homeScore"];
            re["goals_Away_OT"] = data["awayScore"];
          }
        }
        if (data["endedAfter"] == "SHOUTOUTS") {
          re["goals_Home_Pen"] = data["shoutoutHomeScore"];
          re["goals_Away_Pen"] = data["shoutoutAwayScore"];
        }
      }
    }
   return re;
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
