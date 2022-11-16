import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class PronostiekProgression extends StatelessWidget {
  const PronostiekProgression({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(builder: (controller) {
      if (controller.pronostiek == null) {
        return const CircularProgressIndicator();
      }
      return getProgression(controller);
    });
  }

  Widget getProgression(PronostiekController controller) {
    int total = 0;
    total += controller.pronostiek!.progression.round16.length;
    total += controller.pronostiek!.progression.quarterFinals.length;
    total += controller.pronostiek!.progression.semiFinals.length;
    total += controller.pronostiek!.progression.wcFinal.length;
    total += 1;
    bool pastDeadline =
        controller.utcTime.isAfter(controller.deadlineProgression);
    return Column(mainAxisSize: MainAxisSize.max, children: [
      PronostiekPage.pronostiekHeader(
          "Progression",
          controller.deadlineProgression,
          total,
          controller.nFilledInProgression,
          pastDeadline,
          controller.pronostiek!.progression.getTotalPoints()),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () => controller.updateProgressionPageIdx(
                    controller.progressionPageIdx - 1),
                icon: const Icon(Icons.chevron_left)),
            DotsIndicator(
              dotsCount: 6,
              position: controller.progressionPageIdx * 1.0,
              onTap: (position) {
                controller.updateProgressionPageIdx(position.round());
              },
            ),
            IconButton(
                onPressed: () => controller.updateProgressionPageIdx(
                    controller.progressionPageIdx + 1),
                icon: const Icon(Icons.chevron_right)),
          ]),
      Expanded(child: LayoutBuilder(builder: (context, boxConstraints) {
        controller.progressionController = PageController(
            viewportFraction: min(500 / boxConstraints.maxWidth, 1.0),
            initialPage: controller.progressionPageIdx);
        return PageView(
          onPageChanged: (int page) {
            controller.updateProgressionPageIdx(page, animate: false);
          },
          controller: controller.progressionController,
          children: <Widget>[
            getProgressionCard(
                "GroupStage", Pronostiek.teamIds, 4, controller, 0,
                disable: true),
            getProgressionCard("Round of 16 (2pts/team)",
                controller.pronostiek!.progression.round16, 4, controller, 1,
                pastDeadline: pastDeadline),
            getProgressionCard(
                "Quarter Finals (5pts/team)",
                controller.pronostiek!.progression.quarterFinals,
                2,
                controller,
                2,
                pastDeadline: pastDeadline),
            getProgressionCard("Semi Finals (10pts/team)",
                controller.pronostiek!.progression.semiFinals, 2, controller, 3,
                pastDeadline: pastDeadline),
            getProgressionCard("Final (20pts/team)",
                controller.pronostiek!.progression.wcFinal, 2, controller, 4,
                pastDeadline: pastDeadline),
            getProgressionCard("Winner (50pts/team)",
                [controller.pronostiek!.progression.winner], 1, controller, 5,
                pastDeadline: pastDeadline),
          ],
        );
      })),
      if (!pastDeadline) ...[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List<Widget>.generate(8, (i) {
              return Column(
                  children: List<Widget>.generate(4, (j) {
                return SizedBox(
                    width: Get.theme.textTheme.bodyLarge!.fontSize! * 3 * 0.8 +
                        30 +
                        16 +
                        5,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(8.0)),
                      ),
                      onPressed: controller
                              .teamInProgression(Pronostiek.teamIds[i * 4 + j])
                          ? null
                          : () => controller.addTeamToProgression(
                              Pronostiek.teamIds[i * 4 + j]),
                      child: Row(children: [
                        Get.find<MatchController>()
                            .teams[Pronostiek.teamIds[i * 4 + j]]!
                            .getFlag(
                                disabled: controller.teamInProgression(
                                    Pronostiek.teamIds[i * 4 + j])),
                        const VerticalDivider(
                          width: 5,
                          thickness: 0,
                        ),
                        Text(Get.find<MatchController>()
                            .teams[Pronostiek.teamIds[i * 4 + j]]!
                            .shortName),
                      ]),
                    ));
              }));
            }))),
      ]
    ]);
  }

  Widget getProgressionCard(String title, List<String?> teamIds,
      int crossAxisCount, PronostiekController controller, int pageIdx,
      {bool disable = false, bool pastDeadline = false}) {
    crossAxisCount = (crossAxisCount / (pastDeadline ? 2 : 1)).round();
    int mainAxisCount = (teamIds.length / crossAxisCount).round();
    List<bool?> correction = controller.pronostiek!.progression.getCorrection(
        teamIds.map((e) => Get.find<MatchController>().teams[e]).toList(),
        pageIdx);
    return Card(
        child: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.5,
        ),
        if (!disable && pastDeadline) ...[
          Text(
            "Points: ${correction.fold(0, (v, e) => e ?? false ? v + 1 : v) * ProgressionPronostiek.getPointsPerTeam(pageIdx)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
            textScaleFactor: 1.5,
          ),
        ],
        const Divider(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(mainAxisCount, (i) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(crossAxisCount, (j) {
                  int index = i * crossAxisCount + j;
                  return Row(children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                            width: Get.theme.textTheme.bodyMedium!.fontSize! *
                                    3 *
                                    0.8 +
                                30 +
                                16 +
                                5,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(8.0)),
                                ),
                                onPressed: (disable ||
                                        pastDeadline ||
                                        controller.progressionPageIdx !=
                                            pageIdx)
                                    ? null
                                    : (teamIds[index] != null
                                        ? () => controller
                                            .removeTeamFromProgression(
                                                teamIds[index]!)
                                        : null),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (teamIds[index] != null) ...[
                                        Get.find<MatchController>()
                                            .teams[teamIds[index]]!
                                            .getFlag(),
                                      ],
                                      const VerticalDivider(
                                        thickness: 0,
                                        width: 5,
                                      ),
                                      Text(Get.find<MatchController>()
                                              .teams[teamIds[index]]
                                              ?.shortName ??
                                          ""),
                                    ])))),
                    if (!disable & pastDeadline) ...[
                      correction[index] == null
                          ? const Icon(
                              Icons.help_outline,
                            )
                          : correction[index]!
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.cancel_outlined,
                                  color: Colors.red)
                    ]
                  ]);
                }));
          }),
        ),
      ],
    )));
  }
}
