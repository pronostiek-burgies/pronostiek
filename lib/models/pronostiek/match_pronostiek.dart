import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/icon_image_provider.dart';
import 'package:pronostiek/models/match.dart';

class MatchPronostiek {
  late String matchId;
  int? goalsHomeFT;
  int? goalsAwayFT;
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
  /// 
  /// knockout
  /// FT win/lost normal
  /// OT/pen: 3pts predict draw (+4 if correct winner)
  /// factor: R16: 1.5, QF: 2, SF: 3, F: 4, f:1S
  /// 
  int? getPronostiekPoints() {
    Match match = Get.find<MatchController>().matches[matchId]!;
    if (match.status != MatchStatus.ended) {return null;}
    int pointsHome = 0;
    if (goalsHomeFT == null || goalsHomeFT == null) {return 0;}
    if (goalsHomeFT! < goalsHomeFT!) { 
      pointsHome = 0;
    } else if (goalsHomeFT! > goalsHomeFT!) {
      pointsHome = 3;
    } else {
      pointsHome = 1;
    }
    return match.getPoints(true) == pointsHome ? 10 : 0;
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
              Text(match.home!.name, style: TextStyle(fontWeight: (match.knockout && (winner ?? false)) ? FontWeight.bold: FontWeight.normal),)
            ] else ...[
              Text(match.linkHome!, style: TextStyle(fontWeight: (match.knockout && (winner ?? false)) ? FontWeight.bold: FontWeight.normal),),
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
                      value: !(winner ?? false),
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
                      onChanged: scoreDraw ? (v) => controller.updateMatchWinner(!v, match.id) : null,
                    ),
                  ],
                  Row(children: [
                    SizedBox(
                      width: 24,
                      child: TextFormField(
                        controller: controllers.first,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: "", isDense: true),
                        maxLength: 2,
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
                        maxLength: 2,
                        textAlign: TextAlign.center,
                        onChanged: (v) => controller.updateMatchWinner(winnerByGoals(), match.id),
                        readOnly: disabled,
                      )
                    )
                  ],),
                ],
              ),
            ]
          )),

          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (match.away != null) ... [
                Text(match.away!.name, style: TextStyle(fontWeight: (match.knockout && !(winner ?? true)) ? FontWeight.bold: FontWeight.normal),),
                const VerticalDivider(thickness: null,),
                match.away!.getFlag(),
              ] else ...[
                Text(match.linkAway!, style: TextStyle(fontWeight: (match.knockout && !(winner ?? true)) ? FontWeight.bold: FontWeight.normal),),
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