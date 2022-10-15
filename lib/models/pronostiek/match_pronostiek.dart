import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
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

  Map<String,dynamic> toJSON() {
    return {
      "match_id": matchId,
      "goals_home_FT": goalsHomeFT,
      "goals_away_FT": goalsAwayFT,
      "winner": winner,
    };
  }

  ListTile getListTile(List<TextEditingController> controllers) {
    Match match = Get.find<MatchController>().matches[matchId]!;
    return ListTile(
      leading: Text(matchId),
      title: Row(
        children: [
          Expanded(child: Row(children: [
            if (match.home != null) ... [
              match.home!.getFlag(),
              const VerticalDivider(thickness: 0,),
              Text(match.home!.name)
            ] else ...[
              Text(match.linkHome!),
            ],
          ])),
          
          Row(children: [
            SizedBox(
              width: 24,
              child: TextFormField(
                controller: controllers.first,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: "", isDense: true),
                maxLength: 2,
                textAlign: TextAlign.center,
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
              )
            )
          ],),

          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (match.away != null) ... [
                Text(match.away!.name),
                const VerticalDivider(thickness: 0,),
                match.away!.getFlag(),
              ] else ...[
                Text(match.linkAway!),
              ],
            ]
          )),
        ]
      ),
    );
  }
}