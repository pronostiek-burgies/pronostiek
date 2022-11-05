import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/group.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/team.dart';


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

  MatchController matchController = Get.find<MatchController>();


  static ResultController get to => Get.find<ResultController>();

  ResultController() {
    progression[0] = matchController.teams.values.toList();
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