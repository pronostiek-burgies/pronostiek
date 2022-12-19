import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pronostiek/api/client.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/group.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/user.dart';


class ResultController extends GetxController {
  /// 2D list which contains how far teams progressed in the tournament
  /// 
  /// The first element of [teamsEndStage] contains all the teams who stranded in the group phase.
  /// The second element of [teamsEndStage] contains all the teams who stranded in the round of 16...
  List<List<Team>> teamsEndStage = [[], [], [], [], [], []];

  /// 2D list which contains teams progressed to which stage the tournament
  /// 
  /// The first element of [progression] contains all the teams who reached the group phase.
  /// The second element of [progression] contains all the teams who reached the round of 16...
  List<List<Team>> progression = [[], [], [], [], [], []];

  Random random = Random();

  bool initialized = false;


  List<RandomPronostiek> randomQuestions = RandomPronostiek.getQuestions();

  MatchController matchController = Get.find<MatchController>();
  Repository repo = Get.find<Repository>();

  List<String> usernames = [];
  Map<String,Pronostiek> pronostieks = {};
  List<RandomPronostiek> solutionRandom = [];
  Map<String,User> users = {};
  Map<String,Color> profileColors = {};

  static ResultController get to => Get.find<ResultController>();

  ResultController() {
    progression[0] = matchController.teams.values.toList();
    if (kIsWeb) {
      int n_initialized = 0;
      if (WebStorage.instance.randomQuestions != null) {
        randomQuestions = List<RandomPronostiek>.from(jsonDecode(WebStorage.instance.randomQuestions!).map((e) => RandomPronostiek.fromJson(e))); 
        n_initialized++;
      }
      if (WebStorage.instance.usernames != null) {
        usernames = List<String>.from(jsonDecode(WebStorage.instance.usernames!)); 
        n_initialized++;
      }
      if (WebStorage.instance.pronostieks != null) {
        pronostieks = Map<String,Pronostiek>.from(jsonDecode(WebStorage.instance.pronostieks!).map((k,v) => MapEntry(k,Pronostiek.fromJson(v)))); 
        n_initialized++;
      }
      if (WebStorage.instance.randomSolution != null) {
        solutionRandom = List<RandomPronostiek>.from(jsonDecode(WebStorage.instance.randomSolution!).map((e) => RandomPronostiek.fromJson(e))); 
        n_initialized++;
      }
      if (WebStorage.instance.users != null) {
        users = Map<String,User>.from(jsonDecode(WebStorage.instance.users!).map((k,v) => MapEntry(k, User.fromJson(v)))); 
        n_initialized++;
      }
      if (WebStorage.instance.profileColors != null) {
        profileColors = Map<String,Color>.from(jsonDecode(WebStorage.instance.profileColors!).map((k,v) => MapEntry(k, User.colorFromString(v)))); 
        n_initialized++;
      }
      if (n_initialized == 6) {initialized = true;}
    }
    update();
  }

  Future<void> init() async {
    randomQuestions = await repo.getRandomSolution();
    WebStorage.instance.randomQuestions = jsonEncode(randomQuestions);
    usernames = (await repo.getUsernames()).where((element) => element != "admin").toList();
    WebStorage.instance.usernames = jsonEncode(usernames);
    pronostieks = await repo.getOtherUsersPronostiek(usernames);
    WebStorage.instance.pronostieks = jsonEncode(pronostieks);
    solutionRandom = (await repo.getOtherUsersPronostiek(["admin"]))["admin"]!.random;
    WebStorage.instance.randomSolution = jsonEncode(solutionRandom);
    for (String username in usernames) {
      User user = await repo.getUserDetails(username);
      profileColors[username] = user.color;
      users[username] = user;
      user.profilePicture = await repo.getProfilePicture(user);
    }
    WebStorage.instance.users = jsonEncode(users);
    WebStorage.instance.profileColors = jsonEncode(profileColors.map((k,v) => MapEntry(k, v.toString())));
    initialized = true;
    update();
  }

  void refreshSolution() {
    init();
  }

  Map<String,int> getAllMatchPoints() {
    return pronostieks.map((key, Pronostiek value) => MapEntry(key, value.getAllMatchPoints()));
  }

  Map<String,int> getAllProgressionPoints() {
    return pronostieks.map((key, Pronostiek value) => MapEntry(key, value.progression.getTotalPoints()));
  }

  Map<String,int> getAllRandomPoints() {
    return pronostieks.map((key, Pronostiek value) => MapEntry(key, value.random.fold(0, (v,e) => v + (getRandomPoints(e) ?? 0))));
  }

  Map<String,Map<DateTime,dynamic>> getPointsPerDay(DateTime startDate, DateTime endDate, {startZero=false}) {
    Map<String,Map<DateTime,dynamic>> points = pronostieks.map<String,Map<DateTime,dynamic>>((k, v) => MapEntry(k, startZero ? {startDate.subtract(const Duration(days: 1)): [0, ""]} : {}));
    for (String username in points.keys) {
      DateTime currentDay = startDate;
      while (currentDay.year <= endDate.year && currentDay.month <= endDate.month && currentDay.day <= endDate.day) {
        int? pointsCurrentDay = pronostieks[username]!.getDayMatchPoints(currentDay);
        if (pointsCurrentDay != null) {
          points[username]![currentDay] = [pronostieks[username]!.getDayMatchPoints(currentDay), DateFormat("dd/MM").format(currentDay)];
        }
        points[username]![currentDay.add(const Duration(hours: 1))] = pronostieks[username]!.progression.getPointsPerDay(currentDay);
        currentDay = currentDay.add(const Duration(days: 1));
      }
      points[username]!.removeWhere((key, value) => value == null);
    }
    return points;
  }

  String? getCorrectAnswer(RandomPronostiek question) {
    return solutionRandom.firstWhereOrNull((element) => element.id == question.id)?.answer;
  }

  String? getClosestAnswer(RandomPronostiek question) {
    int? correctAnswer = int.tryParse(getCorrectAnswer(question) ?? "");
    if (correctAnswer == null) {return null;}
    List<int> otherAnswers = [];
    for (Pronostiek pronostiek in pronostieks.values) {
      int? answer = int.tryParse(pronostiek.random.firstWhereOrNull((element) => element.id == question.id)?.answer ?? "");
      if (answer != null) {
        otherAnswers.add(answer);
      }
    }
    print("random: $otherAnswers");
    if (otherAnswers.isEmpty) {return null;}
    String answer = otherAnswers[0].toString();
    int distance = (otherAnswers[0] - correctAnswer).abs();
    for (int i in List.generate(otherAnswers.length-1, (index) => index+1)) {
      if ((otherAnswers[i] - correctAnswer).abs() < distance) {
        answer = otherAnswers[i].toString();
        distance = (otherAnswers[i] - correctAnswer).abs();
      } else if ((otherAnswers[i] - correctAnswer).abs() == distance) {
        answer += ";${otherAnswers[i]}";
      }
    }
    return answer;
  }

  int? getRandomPoints(RandomPronostiek question) {
    String? answer;
    if (question.criterium == ScoreCriterium.exact) {
      answer = getCorrectAnswer(question);
    } else if (question.criterium == ScoreCriterium.closest) {
      answer = getClosestAnswer(question);
    }
    if (answer == null) {return null;}
    return answer.split(";").contains(question.answer) ? RandomPronostiek.points : 0;
  }

  void updateTeamsEndStage() {
    void updateFromKnockout(MatchType type, int i, int count) {
      if (teamsEndStage[i].length < count) {
        progression[i+1] = [];
        teamsEndStage[i] = [];
        for (Match match in matchController.matches.values.where((e) => e.type == MatchType.values[i])) {
          Team? winner = match.getWinner();
          Team? loser = match.getLoser();
          if (winner != null) {
            progression[i+1].add(winner);
          }
          if (loser != null) {
            teamsEndStage[i].add(loser);
          }
        }
      }
    }

    // update group stage if needed
    if (teamsEndStage[0].length < 16) {
      progression[1] = [];
      teamsEndStage[0] = [];
      for (Group group in matchController.groups.values) {
        if (group.finished()) {
          group.setRanked();
          progression[1].add(group.ranked[0]);
          progression[1].add(group.ranked[1]);
          teamsEndStage[0].add(group.ranked[2]);
          teamsEndStage[0].add(group.ranked[3]);
        }
      }
    }
    updateFromKnockout(MatchType.roundOf16, 1, 8);
    updateFromKnockout(MatchType.quarterFinals, 2, 4);
    updateFromKnockout(MatchType.semiFinals, 3, 2);
    updateFromKnockout(MatchType.wcFinal, 4, 1);

    update();
  }

 

}