
import 'package:pronostiek/models/initMatches.dart';
import 'package:pronostiek/models/initTeams.dart';
import 'package:pronostiek/models/match.dart';
import 'package:get/get.dart';
import 'package:pronostiek/models/team.dart';

import 'package:pronostiek/main.dart';

class MatchController extends GetxController {
  Map<String,Team> teams = getTeams();
  Map<String,Match> matches = {};

  static MatchController get to => Get.find<MatchController>();

  MatchController() {
    matches = getMatches(teams);
  }

  List<String> getSortedKeys() {
    List<String> keys = matches.keys.toList();
    keys.sort((a, b) => matches[a]!.startDateTime.compareTo(matches[b]!.startDateTime));
    return keys;
  }

  void getResults() async {
    matches["A1"]!.id = await repo.readDropboxFile("/test.txt");
    update()
  }


}