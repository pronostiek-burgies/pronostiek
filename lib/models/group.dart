import 'package:flutter/foundation.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/match.dart';

class Group {
  String name;
  List<Team> teams;
  List<Match> matches;
  late List<Team> ranked;
  List<int> rankingPoints;

  static List<List<int>> comb = [[0,1,2,3],
                                 [1,2,3],
                                 [0,2,3],
                                 [0,1,3],
                                 [0,1,2],
                                 [0,1],
                                 [0,2],
                                 [0,3],
                                 [1,2],
                                 [1,3],
                                 [2,3]];

  Group(this.name, this.teams, this.matches, {this.rankingPoints=const [0,1,2,3]}) {
    ranked = teams;
  }

  bool finished() {
    return !matches.any((element) => element.status != MatchStatus.ended);
  }

  Map<String, Map<String,List<int>>> calcStats() {
    // init data structure
    Map<String, Map<String,List<int>>> re = {};
    for (int i=0;i<4;i++) {
      Team team = teams[i];
      re[team.id] = {};
      String key = "";
      for (List<int> e in comb) {
        if (e.contains(i)) {
          key = "";
          for (int idx in e) {
            if (idx != i) {
              key += teams[i].id;
            }
          }
          re[team.id]![key] = [0, 0, 0];
        }
      }
    }

    // filling in data structure
    for (Match match in matches.where((match) => match.status == MatchStatus.ended).toList()) {
      for (Team team in teams) {
        if (team == match.home) {
          for (String comb in re[team.id]!.keys) {
            if (comb.contains(match.away!.id)) {
              re[team.id]![comb]![0] += match.getPoints(true)!; // points
              re[team.id]![comb]![1] += (match.goalsHomeFT! - match.goalsAwayFT!); // goal saldo
              re[team.id]![comb]![0] += match.goalsHomeFT!; // scored goals
            }
          }
        }
        if (team == match.away) {
          for (String comb in re[team.id]!.keys) {
            if (comb.contains(match.home!.id)) {
              re[team.id]![comb]![0] += match.getPoints(false)!; // points
              re[team.id]![comb]![1] += (match.goalsAwayFT! - match.goalsHomeFT!); // goal saldo
              re[team.id]![comb]![0] += match.goalsAwayFT!; // scored goals
            }
          }
        }
      }
    }
    return re;  
  }

  void setRanked() {
    List<Team> ranked = [...teams];
    Map<String, Map<String,List<int>>> stats = calcStats();

    // STEP 1 (all group matches)
    // points > goal diff > goals scored
    // sort
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![2].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![2]));
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![1].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![1]));
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![0].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![0]));
    // check equal ranks
    bool ready = true;
    List<int> equal = [0,1,2,3];
    List<int> prev = stats[ranked[0].id]![_getEqualTeamsKey(teams, ranked[0])]!;
    List<int> cur  = stats[ranked[0].id]![_getEqualTeamsKey(teams, ranked[0])]!;
    for (int i=1; i<4; i++) {
      cur = stats[ranked[i].id]![_getEqualTeamsKey(teams, ranked[i])]!;
      if (listEquals(cur, prev)) {
        ready = false;
        equal[i] = equal[i+1];
        break;
      }
      prev = cur;
    }
    if (ready) {
      this.ranked = ranked;
      return ;
    }
    ranked.sort((a, b) => rankingPoints[teams.indexOf(a)].compareTo(rankingPoints[teams.indexOf(b)]));
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![2].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![2]));
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![1].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![1]));
    ranked.sort((b, a) => stats[a.id]![_getEqualTeamsKey(teams, a)]![0].compareTo(stats[b.id]![_getEqualTeamsKey(teams, b)]![0]));
    this.ranked = ranked;
  }

  String _getEqualTeamsKey(List<Team> teams, Team team) {
    return teams.where((e) => e != team).fold("", ((previousValue, element) => previousValue + element.id));
  }
}