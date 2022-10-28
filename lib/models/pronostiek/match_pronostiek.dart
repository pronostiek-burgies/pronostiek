import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/icon_image_provider.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/widgets/possible_points.dart';

class MatchPronostiek {
  static const Map<MatchType, double> matchTypeMultiplier = {
    MatchType.group:          1.0,
    MatchType.bronzeFinal:    1.0,
    MatchType.roundOf16:      1.5,
    MatchType.quarterFinals:  2,
    MatchType.semiFinals:     3,
    MatchType.wcFinal:        4,
  };

  static const int basePoints = 5;
  static const int basePointsDrawKnockout = 3;
  static const int basePointsDrawKnockoutWinner = 4;

  static const List<int> bonusPointsGoalsSingleTeam = [2, 1, 3, 7, 10, 17, 27, 44, 71, 115, 186];
  static const List<int> bonusPointsTotalGoals = [0,0,0,1,3,6,10,15,21,28,36,45,55,66,78,91,105,120,136,153,171];

  late String matchId;
  int? goalsHomeFT;
  int? goalsAwayFT;
  // winner is home
  bool? winner;

  MatchPronostiek(
    this.matchId,
    this.goalsHomeFT,
    this.goalsAwayFT,
    this.winner,
  );

  MatchPronostiek.fromJson(Map<String,dynamic> json) {
    matchId = json["match_id"];
    goalsHomeFT = json["goals_home_FT"];
    goalsAwayFT = json["goals_away_FT"];
    winner = json["winner"];
  }

  Map<String,dynamic> toJson() {
    return {
      "match_id": matchId,
      "goals_home_FT": goalsHomeFT,
      "goals_away_FT": goalsAwayFT,
      "winner": winner,
    };
  }
 
  static int getBasePoints(
    int correctGoalsHome,
    int correctGoalsAway,
    int predictGoalsHome,
    int predictGoalsAway,{
    bool? correctWinner,
    bool? predictWinner,
    bool knockout=false,
  }) {
    int getWDL(int home, int away) {
      return ((home > away) ? 1 : 0) - ((away > home) ? 1 : 0);
    }
    if (knockout && getWDL(correctGoalsHome, correctGoalsAway) == 0) {
      return (getWDL(predictGoalsHome, predictGoalsAway) == 0 ? basePointsDrawKnockout : 0) + (correctWinner == predictWinner && predictWinner != null ? basePointsDrawKnockoutWinner : 0);
    } else {
      return getWDL(correctGoalsHome, correctGoalsAway) == getWDL(predictGoalsHome, predictGoalsAway) ? basePoints : 0;
    }
  }

  static num bonusPointsFactor(
    int correctGoalsHome,
    int correctGoalsAway,
    int predictGoalsHome,
    int predictGoalsAway,
  ) {
    /// factor = 0 if predicted wrong winner
    if ((correctGoalsHome - correctGoalsAway) * (predictGoalsHome - predictGoalsAway) < 0) {return 0;}
    int goalDifferenceDelta = ((correctGoalsHome - correctGoalsAway).abs() - (predictGoalsHome - predictGoalsAway).abs());
    int goalTotalDelta = ((correctGoalsHome + correctGoalsAway) - (predictGoalsHome + predictGoalsAway).abs()).abs();
    return pow(pi, -2*(
      pow(goalDifferenceDelta,2) / max((predictGoalsHome - predictGoalsAway).abs(), 2)
      + pow(goalTotalDelta,2) / max((predictGoalsHome + predictGoalsAway).abs(), 2)
    ));
  }

  static int getBonusPoints(
    int correctGoalsHome,
    int correctGoalsAway,
    int predictGoalsHome,
    int predictGoalsAway,
  ) {
    int pointsHomeGoals = bonusPointsGoalsSingleTeam[min(10, correctGoalsHome)];
    int pointsAwayGoals = bonusPointsGoalsSingleTeam[min(10, correctGoalsAway)];
    int pointsTotalGoals = bonusPointsTotalGoals[min(20, correctGoalsHome+correctGoalsAway)];
    num factor = bonusPointsFactor(correctGoalsHome, correctGoalsAway, predictGoalsHome, predictGoalsAway);
    return (factor * (pointsHomeGoals + pointsAwayGoals + pointsTotalGoals)).floor();
  }

  static int getPronostiekPointsByScore(
    int correctGoalsHome,
    int correctGoalsAway,
    int predictGoalsHome,
    int predictGoalsAway, {
      /// true if home wins
      bool? correctWinner,
      bool? predictWinner,
      MatchType type=MatchType.group,
      bool knockout=false,
    }) {

    int basePoints = getBasePoints(
      correctGoalsHome,
      correctGoalsAway,
      predictGoalsHome,
      predictGoalsAway,
      correctWinner: correctWinner,
      predictWinner: predictWinner,
      knockout: knockout
    );
    int bonusPoints = getBonusPoints(
      correctGoalsHome,
      correctGoalsAway,
      predictGoalsHome,
      predictGoalsAway,
    );
    double multiplier = matchTypeMultiplier[type]!;
    
    return ((basePoints + bonusPoints) * multiplier).floor();
  }

  int? getPronostiekPoints() {
    Match match = Get.find<MatchController>().matches[matchId]!;
    if (match.status != MatchStatus.ended) {return null;}
    if (goalsHomeFT == null || goalsHomeFT == null) {return 0;}
    return getPronostiekPointsByScore(
      match.goalsHomeFT!,
      match.goalsAwayFT!,
      goalsHomeFT!,
      goalsAwayFT!,
      correctWinner: match.getWinner() == match.home,
      predictWinner: winner,
      type: match.type,
      knockout: match.knockout
    );
  }

  ListTile getListTile(PronostiekController controller, List<TextEditingController> controllers, bool disabled) {
    bool? winnerByGoals() {
      if (controllers[1].text == "" || controllers[0].text == "") {return null;}
      return int.parse(controllers[0].text) >= int.parse(controllers[1].text);
    }
    Match match = Get.find<MatchController>().matches[matchId]!;
    bool scoreDraw = controllers[0].text == controllers[1].text;
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Row(children: [
            Text(matchId),
            const VerticalDivider(thickness: 0,),
            if (match.home != null) ... [
              match.home!.getFlag(),
              const VerticalDivider(thickness: null,),
              Text(match.home!.name, style: TextStyle(fontWeight: (!disabled && match.knockout && (winner ?? false)) ? FontWeight.bold: FontWeight.normal),)
            ] else ...[
              Text(match.linkHome!, style: TextStyle(fontWeight: (!disabled && match.knockout && (winner ?? false)) ? FontWeight.bold: FontWeight.normal),),
            ],
          ])),
          IntrinsicHeight(child: Row(
            children: [
              if (disabled) ...[
                match.getScoreBoardMiddle(),
                VerticalDivider(color: wcRed, thickness: 1.0),
              ],          
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (match.knockout && winner != null) ... [
                    Switch(
                      value: !(winner!),
                      inactiveTrackColor: wcRed[200],
                      activeTrackColor: wcRed[200],
                      inactiveThumbColor: wcRed,
                      activeColor: wcRed,
                      activeThumbImage: IconImageProvider(Icons.emoji_events),
                      inactiveThumbImage: IconImageProvider(Icons.emoji_events),
                      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return wcRed[500];
                        }
                          return wcRed;
                        }),
                      onChanged: disabled ? null : scoreDraw ? (v) => controller.updateMatchWinner(!v, match.id) : null,
                    ),
                  ],
                  Row(children: [
                    SizedBox(
                      width: 24,
                      child: TextFormField(
                        controller: controllers.first,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: "", isDense: true),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (v) => controller.updateMatchWinner(winnerByGoals(), match.id),
                        readOnly: disabled,
                      )
                    ),
                    const Text("-"),
                    SizedBox(
                      width: 24,
                      child: TextFormField(
                        controller: controllers.last,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: "", isDense: true),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (v) => controller.updateMatchWinner(winnerByGoals(), match.id),
                        readOnly: disabled,
                      )
                    )
                  ],),
                ],
              ),
              if (!disabled) ...[
              IconButton(
                onPressed: () {Get.defaultDialog(
                  title: "How to earn points?",
                  content: PossiblePointsWidget(int.tryParse(controllers[0].text), int.tryParse(controllers[1].text), match),
                );},
                icon: const Icon(Icons.help_outline)
              )
              ],
            ]
          )),

          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (match.away != null) ... [
                Text(match.away!.name, style: TextStyle(fontWeight: (!disabled && match.knockout && !(winner ?? true)) ? FontWeight.bold: FontWeight.normal),),
                const VerticalDivider(thickness: null,),
                match.away!.getFlag(),
              ] else ...[
                Text(match.linkAway!, style: TextStyle(fontWeight: (!disabled && match.knockout && !(winner ?? true)) ? FontWeight.bold: FontWeight.normal),),
              ],
              if (disabled) ... [
                IntrinsicHeight(child: Row(children: [
                  VerticalDivider(color: wcRed, thickness: 1.0),
                  Text("Pts: ${getPronostiekPoints() ?? "?"}")
                ],))
              ]
            ]
          )),
        ]
      ),
    );
  }
}