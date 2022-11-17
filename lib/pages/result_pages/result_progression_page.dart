import 'dart:math';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/controllers/result_controller.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/user.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class ResultProgressionPage extends StatefulWidget {
  const ResultProgressionPage({super.key});

  @override
  State<ResultProgressionPage> createState() => _ResultProgressionPageState();
}

class _ResultProgressionPageState extends State<ResultProgressionPage> {
  int _pageIdx = 1;
  PageController _pageController = PageController(
      viewportFraction: min(500 / Get.width, 1.0), initialPage: 1);

  void changePageIndex(int idx, {bool animate = true}) {
    if (idx > 4) {
      idx = 4;
    }
    if (idx < 0) {
      idx = 0;
    }
    if (animate) {
      _pageController.animateToPage(idx,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
    setState(() {
      _pageIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResultController>(builder: (controller) {
      if (Get.find<PronostiekController>()
          .utcTime
          .isBefore(Get.find<PronostiekController>().deadlineProgression)) {
        return const Text(
            "Info not available. Wait until the deadline has passed.");
      }
      if (!controller.initialized) {
        return const CircularProgressIndicator();
      }
      return getProgression(controller);
    });
  }

  List<Map<Team,List<User>>> getChosenTeams(ResultController controller) {
    final teams = MatchController.to.teams;
    List<Map<Team,List<User>>> chosenTeams = [];
    for (int i=0; i<5; i++) {
      Map<Team,List<User>> chosenTeamsPerStage = {};
      for (String username in controller.usernames) {
        for (String? teamId in controller.pronostieks[username]!.progression.toList()[i]) {
          if (teamId != null) {
            chosenTeamsPerStage.update(teams[teamId]!, (value) => value + [controller.users[username]!], ifAbsent: () => [controller.users[username]!]);
          }
        }
      }
      chosenTeams.add(chosenTeamsPerStage);
    }
    return chosenTeams;
  }

  Widget getProgression(ResultController controller) {
    List<Map<Team,List<User>>> chosenTeams = getChosenTeams(controller);
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () => changePageIndex(_pageIdx - 1),
                icon: const Icon(Icons.chevron_left)),
            DotsIndicator(
              dotsCount: 5,
              position: _pageIdx * 1.0,
              onTap: (position) {
                changePageIndex(position.round());
              },
            ),
            IconButton(
                onPressed: () => changePageIndex(_pageIdx + 1),
                icon: const Icon(Icons.chevron_right)),
          ]),
      Expanded(child: LayoutBuilder(builder: (context, boxConstraints) {
        _pageController = PageController(
            viewportFraction: min(500 / boxConstraints.maxWidth, 1.0),
            initialPage: _pageIdx);
        return PageView(
          onPageChanged: (int page) {
            changePageIndex(page, animate: false);
          },
          controller: _pageController,
          children: <Widget>[
            getProgressionCard("Round of 16", chosenTeams[0], 0, controller),
            getProgressionCard("Quarter Finals", chosenTeams[1], 1, controller),
            getProgressionCard("Semi-Finals", chosenTeams[2], 2, controller),
            getProgressionCard("Final", chosenTeams[3], 3, controller),
            getProgressionCard("Winner", chosenTeams[4], 4, controller),

          ],
        );
      })),
    ]);
  }

  Widget getProgressionCard(String title, Map<Team, List<User>> teams, int pageIdx,
      ResultController controller) {
    List<bool?> correctionList = ProgressionPronostiek.getCorrectionStatic(teams.keys.toList(), pageIdx+1);
    Map<Team,bool?> correction = correctionList.asMap().map<Team,bool?>((int i, e) => MapEntry(teams.keys.toList()[i], e));
    List<Team> sortedTeams = teams.keys.toList();
    sortedTeams.sort((b, a) => teams[a]!.length.compareTo(teams[b]!.length));
    return Card(
      clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.5,
        ),
        const Divider(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: sortedTeams.map<Widget>((Team team) {
            return Row(children: [
              const SizedBox(width: 8.0,),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                      width:
                          Get.theme.textTheme.bodyMedium!.fontSize! * 3 * 0.8 +
                              30 +
                              16 +
                              5,
                      child: OutlinedButton(
                          onPressed: null,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(8.0)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                team.getFlag(),
                                const VerticalDivider(
                                  thickness: 0,
                                  width: 5,
                                ),
                                Text(team.shortName),
                              ])))),
                              const SizedBox(width: 8.0,),
                              correction[team] == null
                  ? const Icon(
                      Icons.help_outline,
                    )
                  : correction[team]!
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        )
                      : const Icon(Icons.cancel_outlined,
                          color: Colors.red),
                              const SizedBox(width: 8.0,),
                Row(children: 
                  teams[team]!.expand<Widget>((e) => [e.getProfilePicture(border: false), const SizedBox(width: 4.0)]).toList()
                ),

              
            ]);
          }).toList(),
        ),
      ]),
    ));
  }
}
