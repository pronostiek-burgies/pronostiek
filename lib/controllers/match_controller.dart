
import 'dart:math';

import 'package:pronostiek/api/match_repository.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/api/sportdataapi.dart';
import 'package:pronostiek/api/time_client.dart';
import 'package:pronostiek/models/group.dart';
import 'package:pronostiek/models/init_groups.dart';
import 'package:pronostiek/models/init_matches.dart';
import 'package:pronostiek/models/init_players.dart';
import 'package:pronostiek/models/init_teams.dart';
import 'package:pronostiek/models/match.dart';
import 'package:get/get.dart';
import 'package:pronostiek/models/team.dart';

class MatchController extends GetxController {
  Map<String,Team> teams = getTeams();
  Map<String,Match> matches = {};
  Map<String,Group> groups = {};
  List<String> players = [];
  MatchRepository repo = MatchRepository();


  TimeClient timeClient = Get.find<TimeClient>();
  Random random = Random();

  var tabIndex = 0;
  late DateTime utcTime;

  static MatchController get to => Get.find<MatchController>();

  MatchController() {
    matches = getMatches(teams, this);
    groups = getGroups(teams, matches);
    players = getPlayers();
  }

  Future<void> init() async {
    await updateAllMatches();
    // await setRefresher();
  }

  Future<void> setRefresher() async {
    utcTime = await timeClient.getTime();
    List<Match> busyMatches = matches.values.where((Match e) => e.isBusy()).toList();
    Duration timeUntilUpdate;
    if (busyMatches.isNotEmpty) {
      timeUntilUpdate = Duration(minutes: 1, seconds: random.nextInt(60));
    } else {
      List<DateTime> startTimes = matches.values.where((Match e) => e.status != MatchStatus.ended).map((Match e) => e.startDateTime).toList();
      DateTime timeUntilMatch = startTimes.reduce((value, element) => value.isBefore(element) ? value : element);
      if (timeUntilMatch.isBefore(utcTime)) {
        timeUntilUpdate = Duration(minutes: 1, seconds: random.nextInt(60));
      } else {
        timeUntilUpdate = timeUntilMatch.difference(utcTime) + Duration(minutes: 1, seconds: random.nextInt(60));
      }
    }
    Future.delayed(timeUntilUpdate, () {
      print("ezr");
      fetchLiveResults();
      setRefresher();
    });
  }

  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  List<String> getSortedKeys() {
    List<String> keys = matches.keys.toList();
    keys.sort((a, b) => matches[a]!.startDateTime.compareTo(matches[b]!.startDateTime));
    return keys;
  }

  void saveAllMatches() {
    repo.saveAllMatches(matches);
  }

  Future<void> updateAllMatches() async {
    await repo.getAllMatches(matches);
    update();
  }

  void getStatus() {
    // sportDataApiClient.getStatus();
  }

  void getLiveMatches() {
    repo.fetchLiveMatchResults(matches, DateTime.now());
  }

  void fetchLiveResults() {
    repo.fetchLiveMatchResults(matches, DateTime.now());
  }


}