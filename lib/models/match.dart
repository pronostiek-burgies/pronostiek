import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/pages/match_page.dart';

enum MatchStatus {notStarted, inPlay, ended}

enum LiveMatchStatus {regularTime, halfTime, overTime, penalties, unknown}

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
  int? apiSports;
  DateTime startDateTime;
  String? linkHome;
  String? linkAway;
  Function? getHome;
  Function? getAway;
  Team? home;
  Team? away;
  late bool knockout;
  MatchStatus status = MatchStatus.notStarted;
  LiveMatchStatus? liveStatus;
  int? time;
  int? extraTime;
  bool scoreFTChecked = false;

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
    this.apiSports,
    this.knockout=false,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status.name,
      "live_status": liveStatus?.name,
      "time": time,
      "extra_time": extraTime,
      "score_FT_checked": scoreFTChecked,
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
    match.status = MatchStatus.values.firstWhere((element) => element.name == json["status"]);
    match.liveStatus = LiveMatchStatus.values.firstWhereOrNull((element) => element.name == json["live_status"]);
    match.time = json["time"] as int?;
    match.extraTime = json["extra_time"] as int?;
    match.scoreFTChecked = (json["score_FT_checked"] ?? false) as bool;
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

   bool isPastDeadline() {
    PronostiekController pronostiekController = Get.find<PronostiekController>();
    if (pronostiekController.deadlines[id] == null) {return false;}
    return pronostiekController.utcTime.isAfter(pronostiekController.deadlines[id]!.deadline);
  }

  // Tries to set home if still null, returns if home is != null after this call
  bool trySetHome() {
    if (getHome == null) {
      return true;
    }
    home = getHome!.call();
    return home != null;
  }

  // Tries to set away if still null, returns if away is != null after this call
  bool trySetAway() {
    if (getAway == null) {
      return true;
    }
    away = getAway!.call();
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

  String timeToString() {
    if (liveStatus == LiveMatchStatus.halfTime) {return "HT";}
    if (time == null) {return "";}
    if (extraTime == null) {
      return "$time'";
    } else {
      return "$time+$extraTime'";
    }
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
          if (liveStatus == LiveMatchStatus.regularTime) ...[
            Text("$time'"),
            Text("$goalsHomeFT - $goalsAwayFT"),
          ] else if (status == LiveMatchStatus.overTime) ...[
            Text("$time'"),
            Text("$goalsHomeOT - $goalsAwayOT"),
          ] else if (status == LiveMatchStatus.penalties) ...[
            Text("$goalsHomeOT - $goalsAwayOT"),
            Text("($goalsHomePen- $goalsAwayPen)", textScaleFactor: 0.75),
          ] 
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

  ListTile getListTile({bool leading = true, bool openMatchPage=true}) {
    return ListTile(
      onTap: openMatchPage ? () => Get.to(() => MatchPage(id)) : null,
      leading: leading ? Text(id) : null,
      trailing: openMatchPage ? IconButton(icon: const Icon(Icons.more_vert), onPressed: () => Get.to(() => MatchPage(id))) : null,
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
        getScoreBoardMiddle(),
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
    return GestureDetector(onTap: () => Get.to(() => MatchPage(id)), child:Card(
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
    )));
  }
}
