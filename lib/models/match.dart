
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/models/team.dart';

class Match {
  DateTime startDateTime;
  Team home;
  Team away;
  bool knockout;
  bool finished = false;
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
    this.startDateTime,
    this.home,
    this.away,
    this.knockout,
  );

  ListTile getListTile() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: home.getFlag(),
              ),
              Text(home.name)
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Text(DateFormat('MM-dd').format(startDateTime), textScaleFactor: 0.75,),
              Text(DateFormat('kk:mm').format(startDateTime), textScaleFactor: 0.75,),
            ],),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: away.getFlag(),
              ),
              Text(away.name)
            ],
          ),

        ]
      ),
    );
  }
}