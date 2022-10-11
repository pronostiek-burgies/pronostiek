
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
  Team home;
  Team away;
  bool knockout;
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
    this.knockout,
  );

  // void startMatch() {
  //   status = MatchStatus.inPlay;
  // }

  // void updateScoreFT(int time, int goalsHomeFT, int goalsAwayFT) {
  //   if (status != MatchStatus.inPlay) {
  //     throw Exception("First start match");
  //   }
  //   this.goalsHomeFT = goalsHomeFT;
  //   this.goalsAwayFT = goalsAwayFT;
  // }

  // void startOT() {
  //   if (status != MatchStatus.inPlay) {
  //     throw Exception("First start match");
  //   }
  //   status = MatchStatus.overTime;
  // }

  // void updateScoreOT(int time, int goalsHomeOT, int goalsAwayOT) {
  //   if (status != MatchStatus.overTime) {
  //     throw Exception("First start overtime");
  //   }
  //   this.goalsHomeOT = goalsHomeOT;
  //   this.goalsAwayOT = goalsAwayOT;
  // }

  // void startOT() {
  //   if (status != MatchStatus.inPlay) {
  //     throw Exception("First start match");
  //   }
  //   status = MatchStatus.overTime;
  // }
  // void endMatch() {
  //   status = MatchStatus.ended;
  // }

  ListTile getListTile() {
    return ListTile(
      leading: Text(id),
      title: Row(
        children: [
          Expanded(child: Row(children: [
            home.getFlag(),
            const VerticalDivider(thickness: 0,),
            Text(home.name)
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
              Text(away.name),
              const VerticalDivider(thickness: 0,),
              away.getFlag(),
            ]
          )),
        ]
      ),
    );
  }
}