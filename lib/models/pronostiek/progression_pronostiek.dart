

import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/result_controller.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/team.dart';

class ProgressionPronostiek {
  /// list with team ID's
  List<String?> round16 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
  List<String?> quarterFinals = [null,null,null,null,null,null,null,null];
  List<String?> semiFinals = [null,null,null,null];
  List<String?> wcFinal = [null, null];
  String? winner;

  static const int pointsRound16 = 2;
  static const int pointsQuarterFinals = 5;
  static const int pointsSemiFinals = 10;
  static const int pointsWcFinals = 20;
  static const int pointsWinner = 50;

  ProgressionPronostiek();

  ProgressionPronostiek.fromJson(Map<String,dynamic> json) {
    round16 = List<String?>.from(json["round16"]);    
    quarterFinals = List<String?>.from(json["quarter_finals"]);    
    semiFinals = List<String?>.from(json["semi_finals"]);    
    wcFinal = List<String?>.from(json["final"]);
    winner = json["winner"] as String?;  
  }

  Map<String,dynamic> toJson() {
    return {
      "round16": round16,
      "quarter_finals": quarterFinals,
      "semi_finals": semiFinals,
      "final": wcFinal,
      "winner": winner,
    };
  }

  List<bool?> getCorrection(List<Team?> teams, int round) {
    ResultController resultController = Get.find<ResultController>();
    return teams.map<bool?>((e) {
      if (e == null) {return false;}
      if (resultController.progression[round].contains(e)) {
        return true;
      }
      return resultController.teamsEndStage[round-1].contains(e) ? false : null;
    }).toList();
  }

  int getTotalPoints() {
    Map<String,Team> teams = MatchController.to.teams;
    int s = 0;
    s += getCorrection(round16.map((e) => teams[e]).toList(), 1).fold(0, (v, e) => e??false ? v+getPointsPerTeam(1) : v);
    s += getCorrection(quarterFinals.map((e) => teams[e]).toList(), 2).fold(0, (v, e) => e??false ? v+getPointsPerTeam(2) : v);
    s += getCorrection(semiFinals.map((e) => teams[e]).toList(), 3).fold(0, (v, e) => e??false ? v+getPointsPerTeam(3) : v);
    s += getCorrection(wcFinal.map((e) => teams[e]).toList(), 4).fold(0, (v, e) => e??false ? v+getPointsPerTeam(4) : v);
    s += getCorrection([winner].map((e) => teams[e]).toList(), 5).fold(0, (v, e) => e??false ? v+getPointsPerTeam(5) : v);
    return s;
  }

  dynamic getPointsPerDay(DateTime day) {
    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }
    Map<String,Team> teams = MatchController.to.teams;
    if (isSameDay(day, DateTime(2022, 12, 3))) {
      return [getCorrection(round16.map((e) => teams[e]).toList(), 1).fold<int>(0, (v, e) => e??false ? v+getPointsPerTeam(1) : v), "Round of 16"];
    } else if (isSameDay(day, DateTime(2022, 12, 7))) {
      return [getCorrection(quarterFinals.map((e) => teams[e]).toList(), 2).fold<int>(0, (v, e) => e??false ? v+getPointsPerTeam(2) : v), "Quarter Finals"];
    } else if (isSameDay(day, DateTime(2022, 12, 11))) {
      return [getCorrection(semiFinals.map((e) => teams[e]).toList(), 3).fold<int>(0, (v, e) => e??false ? v+getPointsPerTeam(3) : v), "Semi-Finals"];
    } else if (isSameDay(day, DateTime(2022, 12, 15))) {
      return [getCorrection(wcFinal.map((e) => teams[e]).toList(), 4).fold<int>(0, (v, e) => e??false ? v+getPointsPerTeam(4) : v), "Final"];
    } else if (isSameDay(day, DateTime(2022, 12, 19))) {
      return [getCorrection([winner].map((e) => teams[e]).toList(), 5).fold<int>(0, (v, e) => e??false ? v+getPointsPerTeam(5) : v), "Winner"];
    }
    return null;
  }

  static int getPointsPerTeam(int round) {
    switch (round) {
      case 1:
        return ProgressionPronostiek.pointsRound16;
      case 2:
        return ProgressionPronostiek.pointsQuarterFinals;
      case 3:
        return ProgressionPronostiek.pointsSemiFinals;
      case 4:
        return ProgressionPronostiek.pointsWcFinals;
      case 5:
        return ProgressionPronostiek.pointsWinner;
      default:
      return 0;
    }
  }


}