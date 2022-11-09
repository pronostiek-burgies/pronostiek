import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';
import 'package:pronostiek/models/match.dart';

class AdminPage extends StatefulWidget {
  final Widget drawer;
  const AdminPage(this.drawer, {super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(builder: (controller) {
      return Scaffold(
        drawer: widget.drawer,
        appBar: AppBar(
          title: const Text("Pronostiek WK Qatar"),
          actions: [
            if (tabIndex == 1) ...[
              IconButton(
                onPressed: () => controller.save(),
                icon: const Icon(Icons.save)
              )
            ],
          ],
        ),
        bottomNavigationBar: NavigationBar(
            selectedIndex: tabIndex,
            onDestinationSelected: (value) => setState(() => tabIndex = value),
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.scoreboard),
                label: 'Matches',
              ),
              NavigationDestination(
                icon: Icon(Icons.star),
                label: 'Random',
              ),
            ]),
        body: controller.pronostiek == null
            ? const CircularProgressIndicator()
            : <Widget>[
                getMatches(),
                getRandom(controller),
              ][tabIndex],
      );
    });
  }

  Widget getMatches() {
    List<String> matchIds = MatchController.to.matches.keys.toList();
    matchIds.sort((a, b) => MatchController.to.matches[a]!.startDateTime.compareTo(MatchController.to.matches[b]!.startDateTime));
    return ListView(
      children:
          matchIds
          .expand((e) => [AdminMatchTile(e), const Divider()])
          .toList(),
    );
  }

  Widget getRandom(PronostiekController controller) {
    bool pastDeadline = false;
    int filledIn = controller.pronostiek!.random.fold(
        0,
        (int v, RandomPronostiek e) =>
            (e.answer != null && e.answer != "") ? v + 1 : v);
    return Column(children: [
      _pronostiekHeader("Random Questions", controller.deadlineRandom,
          controller.pronostiek!.random.length, filledIn, pastDeadline, 0),
      Form(
          autovalidateMode: AutovalidateMode.always,
          key: controller.randomFormKey,
          child: Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.pronostiek!.random.length * 2,
            itemBuilder: ((context, index) {
              if (index % 2 == 0) {
                return controller.pronostiek!.random[index >> 1].getListTile(
                    controller.textControllersRandom[index >> 1],
                    controller.randomFormKey,
                    controller,
                    pastDeadline);
              }
              return const Divider();
            }),
          )))
    ]);
  }

  Widget _pronostiekHeaderMatchGroup(
    String title,
    DateTime deadline,
    int nToFillIn,
    int filledIn,
    bool pastDeadline,
    int? points,
  ) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(pastDeadline ? Icons.event_busy : Icons.event_available,
              color: Colors.white),
          const VerticalDivider(),
          Text(
            DateFormat('dd/MM kk:mm').format(deadline.toLocal()),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(
          "$filledIn/$nToFillIn",
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.end,
        ),
        if (pastDeadline) ...[
          const VerticalDivider(),
          Text(
            "Pts: $points",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.end,
          ),
        ]
      ]))
    ]);
  }

  Widget _pronostiekHeader(
    String title,
    DateTime deadline,
    int nToFillIn,
    int filledIn,
    bool pastDeadline,
    int? points,
  ) =>
      ListTile(
          tileColor: wcPurple[800],
          title: _pronostiekHeaderMatchGroup(
              title, deadline, nToFillIn, filledIn, pastDeadline, points));
}

class AdminMatchTile extends StatefulWidget {
  final String matchId;
  const AdminMatchTile(this.matchId, {super.key});

  @override
  State<AdminMatchTile> createState() => _AdminMatchTileState();
}

class _AdminMatchTileState extends State<AdminMatchTile> {
  late MatchStatus _status;
  late LiveMatchStatus? _liveStatus;
  late bool _scoreFTChecked;
  late TextEditingController _timeController;
  late TextEditingController _extraTimeController;
  late TextEditingController _goalsHomeFTController;
  late TextEditingController _goalsAwayFTController;
  late TextEditingController _goalsHomeOTController;
  late TextEditingController _goalsAwayOTController;
  late TextEditingController _goalsHomePenController;
  late TextEditingController _goalsAwayPenController;

  @override
  void initState() {
    Match match = MatchController.to.matches[widget.matchId]!;
    _timeController = TextEditingController(text: match.time?.toString() ?? "");
    _extraTimeController = TextEditingController(text: match.extraTime?.toString() ?? "");
    _goalsHomeFTController =
        TextEditingController(text: match.goalsHomeFT?.toString() ?? "");
    _goalsAwayFTController =
        TextEditingController(text: match.goalsAwayFT?.toString() ?? "");
    _goalsHomeOTController =
        TextEditingController(text: match.goalsHomeOT?.toString() ?? "");
    _goalsAwayOTController =
        TextEditingController(text: match.goalsAwayOT?.toString() ?? "");
    _goalsHomePenController =
        TextEditingController(text: match.goalsHomePen?.toString() ?? "");
    _goalsAwayPenController =
        TextEditingController(text: match.goalsAwayPen?.toString() ?? "");
    _status = match.status;
    _liveStatus = match.liveStatus;
    _scoreFTChecked = match.scoreFTChecked;
    super.initState();
  }
  void saveMatch() async {
    MatchController.to.editMatchResult({
      // TODO: add other attributes
      "id": widget.matchId,
      "status": _status.name,
      "live_status": _liveStatus?.name,
      "time": int.tryParse(_timeController.text),
      "extra_time": int.tryParse(_extraTimeController.text),
      "score_FT_checked": _scoreFTChecked,
      "goals_Home_FT": int.tryParse(_goalsHomeFTController.text),
      "goals_Home_OT": int.tryParse(_goalsHomeOTController.text),
      "goals_Home_Pen": int.tryParse(_goalsHomePenController.text),
      "goals_Away_FT": int.tryParse(_goalsAwayFTController.text),
      "goals_Away_OT": int.tryParse(_goalsAwayOTController.text),
      "goals_Away_Pen": int.tryParse(_goalsAwayPenController.text),
    }).then((value) => Get.snackbar("Match data${value ? "" :" NOT"} saved to the server", ""),);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        Match match = controller.matches[widget.matchId]!;
        return Row(
          children: [
            const SizedBox(
              width: 8.0,
            ),
            Text(match.id),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: MatchStatus.values
                    .map((e) => Flexible(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                          Radio<MatchStatus>(
                            value: e,
                            groupValue: _status,
                            onChanged: (MatchStatus? value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
                          Text(e.name),
                        ])))
                    .toList()),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: LiveMatchStatus.values
                    .map((e) => Flexible(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                          Radio<LiveMatchStatus>(
                            toggleable: true,
                            value: e,
                            groupValue: _liveStatus,
                            onChanged: (LiveMatchStatus? value) {
                              setState(() {
                                _liveStatus = value;
                              });
                            },
                          ),
                          Text(e.name),
                        ])))
                    .toList()),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ["FT_checked", "FT_not_checked"]
                    .map((e) => Flexible(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                          Radio<bool>(
                            value: e == "FT_checked" ? true : false,
                            groupValue: _scoreFTChecked,
                            onChanged: (bool? value) {
                              if (value == null) {return;}
                              setState(() {
                                _scoreFTChecked = value;
                              });
                            },
                          ),
                          Text(e),
                        ])))
                    .toList()),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat("dd/MM").format(match.startDateTime)),
                  Text(DateFormat("kk/mm").format(match.startDateTime))
                ]
              ),

            if (match.home == null) ...[
              Expanded(child: Text(match.linkHome!))
            ] else ...[
              Expanded(child: match.home!.getWidget(flagFirst: true)),
            ],
            SizedBox(
              width: 50,
                child: TextField(
              textAlign: TextAlign.center,
              controller: _timeController,
            )),
            const Text("+"),
            SizedBox(
              width: 50,
                child: TextField(
              textAlign: TextAlign.center,
              controller: _extraTimeController,
            )),
            const Text("'"),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsHomeFTController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                      const Text("-"),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsAwayFTController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                    ],
                  )),
                  Flexible(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsHomeOTController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                      const Text("-"),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsAwayOTController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                    ],
                  )),
                  Flexible(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsHomePenController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                      const Text("-"),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _goalsAwayPenController,
                            maxLength: 3,
                            decoration: const InputDecoration(
                                counterText: "", isDense: true),
                          )),
                    ],
                  )),
                ]),
            if (match.away == null) ...[
              Expanded(child: Text(match.linkAway!))
            ] else ...[
              Expanded(child: match.away!.getWidget(flagFirst: false)),
            ],
            IconButton(onPressed: () => saveMatch(), icon: const Icon(Icons.save)),
            const SizedBox(
              width: 8.0,
            ),
          ],
        );
      },
    );
  }
}
