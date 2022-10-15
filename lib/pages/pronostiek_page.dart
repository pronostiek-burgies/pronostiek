import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';

class PronostiekPage extends StatelessWidget {
  final Widget drawer;
  const PronostiekPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(
      builder: (controller) {
        return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            title: const Text("Pronostiek WK Qatar"),
            actions: <Widget>[
              IconButton(onPressed: () => controller.save(), icon: const Icon(Icons.save)),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.tabIndex,
            onDestinationSelected: (value) => controller.changeTabIndex(value),
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.scoreboard),
                label: 'Matches',
              ),
              NavigationDestination(
                icon: Icon(Icons.merge_type),
                label: 'Progression',
              ),
              NavigationDestination(
                icon: Icon(Icons.star),
                label: 'Random',
              ),
            ]
          ),
          body: <Widget>[
            getMatches(controller),
            getProgression(controller),
            getRandom(controller),
          ][controller.tabIndex],
        );
      }
    );
  }

  Widget getMatches(PronostiekController controller) {
    if (controller.pronostiek == null) {
      return const CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: controller.groups.length,
      itemBuilder: (context, index) {
        return getMatchGroup(controller, controller.groups[index], index);
      }
    );
  }

  Widget getProgression(PronostiekController controller) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () => controller.updateProgressionPageIdx(controller.progressionPageIdx-1),
            icon: const Icon(Icons.chevron_left)
          ),
          DotsIndicator(
            dotsCount: 6,
            position: controller.progressionPageIdx*1.0,
            onTap: (position) => controller.updateProgressionPageIdx(position.round()),
          ),
          IconButton(
            onPressed: () => controller.updateProgressionPageIdx(controller.progressionPageIdx+1),
            icon: const Icon(Icons.chevron_right)
          ),
        ]
      ),
      Flexible(child: PageView(
        onPageChanged: (int page) => controller.updateProgressionPageIdx(page),
        controller: controller.progressionController,
        children: <Widget>[
          getProgressionCard("GroupStage", Pronostiek.teamIds, 8, controller, disable: true),
          getProgressionCard("Round of 16", controller.pronostiek!.progression.round16, 8, controller),
          getProgressionCard("Quarter Finals", controller.pronostiek!.progression.quarterFinals, 8, controller),
          getProgressionCard("Semi Finals", controller.pronostiek!.progression.semiFinals, 4, controller),
          getProgressionCard("Final", controller.pronostiek!.progression.wcFinal, 2, controller),
          getProgressionCard("Winner", [controller.pronostiek!.progression.winner], 1, controller),
        ],
      )),
      SingleChildScrollView(scrollDirection: Axis.horizontal,child:Row(
        children: List<Widget>.generate(8, (i) {
          return Column(
            children: List<Widget>.generate(4, (j) {
              return TextButton(
                style: ButtonStyle( 
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(8.0)
                  ),
                ),
                onPressed: controller.teamInProgression(Pronostiek.teamIds[i*4+j]) ? null : () => controller.addTeamToProgression(Pronostiek.teamIds[i*4+j]),
                child: Row(children: [
                  Get.find<MatchController>().teams[Pronostiek.teamIds[i*4+j]]!.getFlag(),
                  Text(Get.find<MatchController>().teams[Pronostiek.teamIds[i*4+j]]!.shortName),
                ]),
              );
            })
          );
        })
      )),
    ]);
  }
  Widget getRandom(PronostiekController controller) {
    return const Text("random");
  }

  Widget getMatchGroup(PronostiekController controller, MatchGroup matchGroup, int idx) {
    List<String> matches = controller.matchIds.where((e) => controller.dealines[e] == matchGroup).toList();
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10), 
      child: Column(
        children: <Widget>[
          ListTile(
            tileColor: const Color.fromARGB(255, 0, 238, 255),
            title: Text("${matchGroup.name} (deadline: ${DateFormat('dd/MM kk:mm').format(matchGroup.deadline)})"),
            trailing: controller.matchGroupCollapsed[idx] ? const Icon(Icons.keyboard_arrow_up) : const Icon(Icons.keyboard_arrow_down),
            onTap: () => controller.toggleGroupCollapse(idx),
          ),
          if (!controller.matchGroupCollapsed[idx]) ...[
            ListView.builder(
              shrinkWrap: true,
              itemCount: matches.length*2,
              itemBuilder: (context, index) {
                if (index%2 == 0) {
                  return controller.pronostiek!.matches[matches[index>>1]]!.getListTile(controller.textControllers[controller.matchIds[index>>1]]!);
                } else {
                  return const Divider();
                }
              }
            )
          ],
        ]
      ),
    );

  }

  Widget getProgressionCard(String title, List<String?> teamIds, int crossAxisCount, PronostiekController controller, {bool disable=false}) {
    int mainAxisCount = (teamIds.length/crossAxisCount).round();
    return SingleChildScrollView(child: Card(child: Column(children: [
      Text(title),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(mainAxisCount, (i) {
          return Column(
            children: List<Widget>.generate(crossAxisCount, (j) {
              return OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(8.0)
                  ),
                ),
                onPressed: disable ? null : (teamIds[i*crossAxisCount+j] != null ? () => controller.removeTeamFromProgression(teamIds[i*crossAxisCount+j]!) : null),
                child: Row(children: [
                  if (teamIds[i*crossAxisCount+j] != null) ...[
                    Get.find<MatchController>().teams[teamIds[i*crossAxisCount+j]]!.getFlag(),
                  ],
                  Text(Get.find<MatchController>().teams[teamIds[i*crossAxisCount+j]]?.shortName ?? ""),
                ]),
              );
            })
          );
        })
      ),
    ],)));
  }

}