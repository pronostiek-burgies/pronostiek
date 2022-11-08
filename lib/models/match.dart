import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/models/team.dart';

enum MatchStatus { notStarted, inPlay, overTime, penalties, ended }

enum MatchType {
  group,
  roundOf16,
  quarterFinals,
  semiFinals,
  wcFinal, // do not change this order!
  bronzeFinal,
}

class Match {
  String id;
  MatchType type;
  int? sportDataApiId;
  int? sporzaApi;
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
    this.type, {
    this.sportDataApiId,
    this.sporzaApi,
  }) {
    knockout = false;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status.index,
      "time": time,
      "goals_Home_FT": goalsHomeFT,
      "goals_Away_FT": goalsAwayFT,
      "goals_Home_OT": goalsHomeOT,
      "goals_Away_OT": goalsAwayOT,
      "goals_Home_Pen": goalsHomePen,
      "goals_Away_Pen": goalsAwayPen,
    };
  }

  static void updateFromJson(
      Map<String, dynamic> json, Map<String, Match> matches) {
    Match? temp = matches[json["id"]];
    if (temp == null) {
      return;
    }
    Match match = temp;
    match.status = MatchStatus.values[json["status"] as int];
    match.time = json["time"] as int?;
    match.goalsHomeFT = json["goals_home_FT"] ?? json["goals_Home_FT"] as int?;
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
    this.type, {
    this.sportDataApiId,
  }) {
    knockout = true;
  }

  // Tries to set home if still null, returns if home is != after this call
  bool trySetHome() {
    if (home != null) {
      return true;
    }
    home = getHome?.call();
    return home != null;
  }

  // Tries to set away if still null, returns if away is != after this call
  bool trySetAway() {
    if (away != null) {
      return true;
    }
    away = getAway?.call();
    return away != null;
  }

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
    if (knockout == false) {
      return null;
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
    if (knockout == false) {
      return null;
    }
    if (goalsHomeOT! != goalsAwayOT!) {
      return goalsHomeOT! < goalsAwayOT! ? home : away;
    }
    return goalsHomePen! < goalsAwayPen! ? home : away;
  }

  Widget getScoreBoardMiddle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (status == MatchStatus.notStarted) ...[
          Text(
            DateFormat('dd/MM').format(startDateTime.toLocal()),
            textScaleFactor: 0.75,
          ),
          Text(
            DateFormat('kk:mm').format(startDateTime.toLocal()),
            textScaleFactor: 0.75,
          ),
        ] else if (status == MatchStatus.inPlay) ...[
          Text("$time'"),
          Text("$goalsHomeFT - $goalsAwayFT"),
        ] else if (status == MatchStatus.overTime) ...[
          Text("$time'"),
          Text("$goalsHomeOT - $goalsAwayOT"),
        ] else if (status == MatchStatus.penalties) ...[
          Text("$goalsHomeOT - $goalsAwayOT"),
          Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
        ] else if (status == MatchStatus.ended) ...[
          if (goalsHomeOT == null) ...[
            const Text("FT"),
            Text("$goalsHomeFT - $goalsAwayFT"),
          ] else ...[
            Text("FT: $goalsHomeFT - $goalsAwayFT"),
            Text("OT: $goalsHomeOT - $goalsAwayOT"),
            if (goalsHomePen != null) ...[
              Text("($goalsHomePen-$goalsAwayPen)", textScaleFactor: 0.75),
            ]
          ]
        ]
      ],
    );
  }

  ListTile getListTile({bool leading = true}) {
    return ListTile(
      leading: leading ? Text(id) : null,
      title: Row(children: [
        Expanded(
            child: Row(children: [
          if (home != null) ...[
            home!.getFlag(),
            const VerticalDivider(
              thickness: 0,
            ),
            Expanded(child:Text(home!.name))
          ] else ...[
            Expanded(child:Text(linkHome!)),
          ],
        ])),
        Column(
          children: [
            if (status == MatchStatus.notStarted) ...[
              Text(
                DateFormat('dd/MM').format(startDateTime.toLocal()),
                textScaleFactor: 0.75,
              ),
              Text(
                DateFormat('kk:mm').format(startDateTime.toLocal()),
                textScaleFactor: 0.75,
              ),
            ] else if (status == MatchStatus.inPlay) ...[
              Text("$time'"),
              Text("$goalsHomeFT - $goalsAwayFT"),
            ] else if (status == MatchStatus.overTime) ...[
              Text("$time'"),
              Text("$goalsHomeOT - $goalsAwayOT"),
            ] else if (status == MatchStatus.penalties) ...[
              Text("$goalsHomeOT - $goalsAwayOT"),
              Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
            ] else if (status == MatchStatus.ended) ...[
              Text("FT${goalsAwayOT != null ? " (+OT)" : ""}"),
              Text(
                  "${goalsHomeOT ?? goalsHomeFT} - ${goalsAwayOT ?? goalsAwayFT}"),
              if (goalsHomePen != null) ...[
                Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
              ]
            ]
          ],
        ),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (away != null) ...[
            Expanded(child: Text(away!.name, textAlign: TextAlign.end)),
            const VerticalDivider(
              thickness: 0,
            ),
            away!.getFlag(),
          ] else ...[
            Expanded(child:Text(linkAway!, textAlign: TextAlign.end,)),
          ]
        ])),
      ]),
    );
  }

  Widget getMatchCard({bool showMatchId = false}) {
    return Card(
        child: Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: IntrinsicHeight(
          child: Row(
        children: [
          Text(id),
          const VerticalDivider(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 20),
                child: Row(
                  children: [
                    if (home != null) ...[
                      home!.getFlag(),
                    ],
                    const SizedBox(width: 8),
                    Text(home?.name ?? linkHome!),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 20),
                child: Row(
                  children: [
                    if (away != null) ...[
                      away!.getFlag(),
                    ],
                    const SizedBox(width: 8),
                    Text(away?.name ?? linkAway!),
                  ],
                ),
              ),
            ],
          )),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (status == MatchStatus.notStarted) ...[
                  Text(DateFormat("dd/MM").format(startDateTime.toLocal())),
                  Text(DateFormat("HH:mm").format(startDateTime.toLocal())),
                ] else if (status == MatchStatus.ended) ...[
                  Text(
                    goalsHomeOT != null ? "FT\n(+OT)" : "FT",
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text("$time'")
                ],
              ],
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (status == MatchStatus.ended || isBusy()) ...[
                  Text(
                      "${goalsHomePen != null ? "($goalsHomePen)" : ""} ${goalsHomeOT ?? goalsHomeFT!}"),
                  const SizedBox(height: 16),
                  Text(
                      "${goalsAwayPen != null ? "($goalsAwayPen)" : ""} ${goalsAwayOT ?? goalsAwayFT!}"),
                ]
              ],
            ),
          ),
        ],
      )),
    ));
  }
}
