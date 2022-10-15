
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
  ) {knockout = false;}

  Match.knockout(
    this.id,
    this.startDateTime,
    this.linkHome,
    this.linkAway,
    this.getHome,
    this.getAway,
  ) {knockout = true;}

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
              Text(DateFormat('dd/MM').format(startDateTime), textScaleFactor: 0.75,),
              Text(DateFormat('kk:mm').format(startDateTime), textScaleFactor: 0.75,),
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
              const Text("FT"),
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