
import 'package:pronostiek/api/repository.dart';
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
  Repository repo = Get.find<Repository>();

  var tabIndex = 0;

  static MatchController get to => Get.find<MatchController>();

  MatchController() {
    matches = getMatches(teams, this);
    groups = getGroups(teams, matches);
    players = getPlayers();
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

  void getResults() async {
    matches["A1"]!.id = await repo.readDropboxFile("/test.txt");
    update();
  }


}