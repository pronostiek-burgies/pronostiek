
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/models/team.dart';

enum MatchStatus {
  notStarted,
  inPlay,
  overTime,
  penalties,
  ended
}

class Match {
  String id;
  int? sportDataApiId;
  DateTime startDateTime;
  String? linkHome;
  String? linkAway;
  Function? getHome;  
  Function? getAway;  
  Team? home;
  Team? away;
  late bool knockout;
  MatchStatus status = MatchStatus.notStarted;
  int? time;
  /// goals after 90 mins
  int? goalsHomeFT;
  /// goals after 90 mins
  int? goalsAwayFT;
  /// goals FT + OT
  int? goalsHomeOT;
  /// goals FT + OT
  int? goalsAwayOT;
  /// goals in pen shoutout
  int? goalsHomePen;
  /// goals in pen shoutout
  int? goalsAwayPen;

  Match(
    this.id,
    this.startDateTime,
    this.home,
    this.away,
    {this.sportDataApiId}
  ) {knockout = false;}

  Map<String,dynamic> toJson() {
    return {
      "id": id,
      "status": status.index,
      "time": time, 
      "goals_home_FT": goalsHomeFT, 
      "goals_Away_FT": goalsAwayFT, 
      "goals_Home_OT": goalsHomeOT, 
      "goals_Away_OT": goalsAwayOT, 
      "goals_Home_Pen": goalsHomePen, 
      "goals_Away_Pen": goalsAwayPen, 
    };
  }

  static void updateFromJson(Map<String,dynamic> json, Map<String,Match> matches) {
    Match? temp = matches[json["id"]];
    if (temp == null) {return;}
    Match match = temp;
    match.status = MatchStatus.values[json["status"] as int];
    match.time = json["time"] as int?;
    match.goalsHomeFT = json["goals_home_FT"] as int?; 
    match.goalsAwayFT = json["goals_Away_FT"] as int?; 
    match.goalsHomeOT = json["goals_Home_OT"] as int?; 
    match.goalsAwayOT = json["goals_Away_OT"] as int?; 
    match.goalsHomePen = json["goals_Home_Pen"] as int?; 
    match.goalsAwayPen = json["goals_Away_Pen"] as int?;
  }


  Match.knockout(
    this.id,
    this.startDateTime,
    this.linkHome,
    this.linkAway,
    this.getHome,
    this.getAway,
    {this.sportDataApiId,}
  ) {knockout = true;}

  bool isBusy() {
    return status != MatchStatus.ended && status != MatchStatus.notStarted;
  }

  int? getPoints(bool home) {
    if (status != MatchStatus.ended) {
      return null;
    }
    if (goalsHomeFT == goalsAwayFT) {
      return 1;
    }
    if (home) {
      return goalsHomeFT! > goalsAwayFT! ? 3 : 0;
    } else {
      return goalsHomeFT! > goalsAwayFT! ? 0 : 3;
    }
  }

  Team? getWinner() {
    if (status != MatchStatus.ended) {
      return null;
    }
    if (goalsHomeFT! != goalsAwayFT!) {
      return goalsHomeFT! > goalsAwayFT! ? home : away;
    }
    if (goalsHomeOT! != goalsAwayOT!) {
      return goalsHomeOT! > goalsAwayOT! ? home : away;
    }
    return goalsHomePen! > goalsAwayPen! ? home : away;
  }

  Team? getLoser() {
    if (status != MatchStatus.ended) {
      return null;
    }
    if (goalsHomeFT! != goalsAwayFT!) {
      return goalsHomeFT! < goalsAwayFT! ? home : away;
    }
    if (goalsHomeOT! != goalsAwayOT!) {
      return goalsHomeOT! < goalsAwayOT! ? home : away;
    }
    return goalsHomePen! < goalsAwayPen! ? home : away;
  }

  ListTile getListTile() {
    return ListTile(
      leading: Text(id),
      title: Row(
        children: [
          Expanded(child: Row(children: [
            if (home != null) ... [
              home!.getFlag(),
              const VerticalDivider(thickness: 0,),
              Text(home!.name)
            ] else ...[
              Text(linkHome!),
            ],
          ])),
          
          Column(children: [
            if (status == MatchStatus.notStarted) ...[
              Text(DateFormat('dd/MM').format(startDateTime.toLocal()), textScaleFactor: 0.75,),
              Text(DateFormat('kk:mm').format(startDateTime.toLocal()), textScaleFactor: 0.75,),
            ]
            else if (status == MatchStatus.inPlay) ...[
              Text("$time'"),
              Text("$goalsHomeFT - $goalsAwayFT"),
            ]
            else if (status == MatchStatus.overTime) ...[
              Text("$time'"),
              Text("$goalsHomeOT - $goalsAwayOT"),
            ]
            else if (status == MatchStatus.penalties) ...[
              Text("$goalsHomeOT - $goalsAwayOT"),
              Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
            ]
            else if (status == MatchStatus.ended) ...[
              Text("FT${goalsAwayFT != null ? " (+OT)" : ""}"),
              Text("${goalsHomeOT ?? goalsHomeFT} - ${goalsAwayOT ?? goalsAwayFT}"),
              if (goalsHomePen != null) ... [
                Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
              ]
            ]
          ],),

          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (away != null) ...[
                Text(away!.name),
                const VerticalDivider(thickness: 0,),
                away!.getFlag(),
              ] else ...[
                Text(linkAway!),
              ]
            ]
          )),
        ]
      ),
    );
  }
}