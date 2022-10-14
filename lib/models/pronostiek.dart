import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/match.dart';

class MatchPronostiek {
  late String matchId;
  late String? goalsHomeFT;
  late String? goalsAwayFT;
  late bool? winner;

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

  ListTile getListTile() {
    Match match = Get.find<MatchController>().matches[matchId]!;
    return ListTile(
      leading: Text(matchId),
      title: Row(
        children: [
          Expanded(child: Row(children: [
            match.home.getFlag(),
            const VerticalDivider(thickness: 0,),
            Text(match.home.name)
          ])),
          
          Row(children: [
            SizedBox(
              width: 24,
              child: TextFormField(
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: "", isDense: true),
                maxLength: 2,
                textAlign: TextAlign.center,
              )
            )
          ],),

          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(match.away.name),
              const VerticalDivider(thickness: 0,),
              match.away.getFlag(),
            ]
          )),
        ]
      ),
    );
  }
}

class MatchGroup {
  String name;
  DateTime deadline;

  MatchGroup(this.name, this.deadline);
}


class Pronostiek {
  List<String> matchIds = ["A1","A3","A2","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6"];

  late String username;
  late List<dynamic> matches;

  Pronostiek(this.username) {
    matches = [];
    for (String id in matchIds) {
      matches.add(MatchPronostiek(id, null, null, null));
    }
  }

  Pronostiek.fromJson(Map<String,dynamic> json) {
    username = json["username"];
    matches = json["matches"].map((match) => MatchPronostiek.fromJson(match)).toList();
  }

  Map<String,dynamic> toJSON() {
    return {
      "username": username,
      "matches": matches.map((match) => match.toJSON()).toList(),
    };
  }

  



}