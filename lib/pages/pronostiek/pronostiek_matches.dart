import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class PronostiekMatches extends StatelessWidget {
  const PronostiekMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(
      builder: (controller) {
        if (controller.pronostiek == null) {
          return const CircularProgressIndicator();
        }
        return SingleChildScrollView(
            child: Column(
          children: getMatchGroups(controller),
        ));
      }
    );
  }

  List<Widget> getMatchGroups(PronostiekController controller) {
    return Iterable<int>.generate(controller.groups.length)
        .map<Widget>((int idx) {
      MatchGroup matchGroup = controller.groups[idx];
      List<String> matches = controller.matchIds
          .where((e) => controller.deadlines[e] == matchGroup)
          .toList();
      int points = matches.fold(
          0,
          (int v, String e) =>
              v +
              (controller.pronostiek!.matches[e]!.getPronostiekPoints() ?? 0));
      int filledIn = matches.fold<int>(0, (int v, String e) {
        MatchPronostiek matchPronostiek = controller.pronostiek!.matches[e]!;
        return (matchPronostiek.goalsHomeFT != null &&
                matchPronostiek.goalsAwayFT != null)
            ? v + 1
            : v;
      });
      bool pastDeadline = controller.utcTime.isAfter(matchGroup.deadline);
      return ListTileTheme(
          tileColor: wcPurple[800],
          child: ExpansionTile(
            maintainState: true,
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: PronostiekPage.pronostiekHeaderMatchGroup(
                matchGroup.name,
                matchGroup.deadline,
                matches.length,
                filledIn,
                pastDeadline,
                points),
            children: matches
                .expand<Widget>((id) => [
                      ListTileTheme(
                          tileColor: Get.theme.listTileTheme.tileColor,
                          child: controller.pronostiek!.matches[id]!
                              .getListTile(
                                  controller,
                                  controller.textControllers[id]!,
                                  pastDeadline)),
                      const Divider(),
                    ])
                .toList(),
          ));
    }).toList();
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
