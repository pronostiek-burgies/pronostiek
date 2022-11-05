import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';

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
          body: controller.pronostiek == null
            ? const CircularProgressIndicator()
            : <Widget>[
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
    return SingleChildScrollView(
      child: Column(
        children: getMatchGroups(controller),
      )
    );
  }

  Widget getProgression(PronostiekController controller) {
    int total = 0;
    total += controller.pronostiek!.progression.round16.length;
    total += controller.pronostiek!.progression.quarterFinals.length;
    total += controller.pronostiek!.progression.semiFinals.length;
    total += controller.pronostiek!.progression.wcFinal.length;
    total += 1;

    return Column(mainAxisSize: MainAxisSize.max, children: [
      ListTile(
        tileColor: wcPurple[800],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: Text("Progression", style: TextStyle(color: Colors.white),)),
            Flexible(child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
              const Icon(Icons.calendar_today, color: Colors.white),
              const VerticalDivider(),
              Text(DateFormat('dd/MM kk:mm').format(controller.deadlineProgression.toLocal()), style: const TextStyle(color: Colors.white),),
            ],)),
            Expanded(child:Text("${controller.nFilledInProgression}/$total", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,)),
          ]
        ),
      ),
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
            onTap: (position) {controller.updateProgressionPageIdx(position.round());},
          ),
          IconButton(
            onPressed: () => controller.updateProgressionPageIdx(controller.progressionPageIdx+1),
            icon: const Icon(Icons.chevron_right)
          ),
        ]
      ),
      Expanded(child: PageView(
        onPageChanged: (int page) {controller.updateProgressionPageIdx(page, animate: false);},
        controller: controller.progressionController,
        children: <Widget>[
          getProgressionCard("GroupStage", Pronostiek.teamIds, 4, controller, 0, disable: true),
          getProgressionCard("Round of 16 (2pts/team)", controller.pronostiek!.progression.round16, 4, controller, 1),
          getProgressionCard("Quarter Finals (5pts/team)", controller.pronostiek!.progression.quarterFinals, 2, controller, 2),
          getProgressionCard("Semi Finals (10pts/team)", controller.pronostiek!.progression.semiFinals, 2, controller, 3),
          getProgressionCard("Final (20pts/team)", controller.pronostiek!.progression.wcFinal, 2, controller, 4),
          getProgressionCard("Winner (50pts/team)", [controller.pronostiek!.progression.winner], 1, controller, 5),
        ],
      )),
      SingleChildScrollView(scrollDirection: Axis.horizontal,child:Row(
        children: List<Widget>.generate(8, (i) {
          return Column(
            children: List<Widget>.generate(4, (j) {
              return SizedBox(width: Get.theme.textTheme.bodyLarge!.fontSize!*3*0.8+30+16+5,child: TextButton(
                style: ButtonStyle( 
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(8.0)
                  ),
                ),
                onPressed: controller.teamInProgression(Pronostiek.teamIds[i*4+j]) ? null : () => controller.addTeamToProgression(Pronostiek.teamIds[i*4+j]),
                child: Row(children: [
                  Get.find<MatchController>().teams[Pronostiek.teamIds[i*4+j]]!.getFlag(disabled: controller.teamInProgression(Pronostiek.teamIds[i*4+j])),
                  const VerticalDivider(width: 5, thickness: 0,),
                  Text(Get.find<MatchController>().teams[Pronostiek.teamIds[i*4+j]]!.shortName),
                ]),
              ));
            })
          );
        })
      )),
    ]);
  }
  Widget getRandom(PronostiekController controller) {
    int filledIn = controller.pronostiek!.random.fold(0, (int v, RandomPronostiek e) => (e.answer != null && e.answer != "") ? v+1 : v);
    return Column(children: [
      ListTile(
        tileColor: wcPurple[800],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text("Random Questions", style: TextStyle(color: Colors.white),)),
              Flexible(child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                const VerticalDivider(),
                Text(DateFormat('dd/MM kk:mm').format(controller.deadlineRandom.toLocal()), style: const TextStyle(color: Colors.white),),
              ],)),
              Expanded(child:Text("$filledIn/${controller.pronostiek!.random.length}", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,)),
            ]
          ),
        ),
      Form(
        autovalidateMode: AutovalidateMode.always,
        key: controller.randomFormKey,
        child: Expanded(child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.pronostiek!.random.length*2,
          itemBuilder: ((context, index) {
            if (index%2 == 0) {
              return controller.pronostiek!.random[index>>1].getListTile(controller.textControllersRandom[index>>1], controller.randomFormKey, controller);
            }
            return const Divider();
          }),
        ))
      )
    ]);
  }

  List<Widget> getMatchGroups(PronostiekController controller) {
    return Iterable<int>.generate(controller.groups.length).map<Widget>((int idx) {
      MatchGroup matchGroup = controller.groups[idx];
      List<String> matches = controller.matchIds.where((e) => controller.deadlines[e] == matchGroup).toList();
      int points = matches.fold(0, (int v, String e) => v + (controller.pronostiek!.matches[e]!.getPronostiekPoints() ?? 0));
      int filledIn = matches.fold<int>(0, (int v, String e) {
        MatchPronostiek matchPronostiek = controller.pronostiek!.matches[e]!;
        return (matchPronostiek.goalsHomeFT != null && matchPronostiek.goalsAwayFT != null) ? v+1 : v;
      });
      bool pastDeadline = controller.utcTime.isAfter(matchGroup.deadline);
      return ListTileTheme(
        tileColor: wcPurple[800],
        child:ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(matchGroup.name, style: const TextStyle(color: Colors.white),)),
              Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                Icon(pastDeadline ? Icons.event_busy : Icons.event_available, color: Colors.white),
                const VerticalDivider(),
                Text(DateFormat('dd/MM kk:mm').format(matchGroup.deadline.toLocal()), style: const TextStyle(color: Colors.white),),
              ],),
              Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("$filledIn/${matches.length}", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                if (pastDeadline) ...[
                  const VerticalDivider(),
                  Text("Pts: $points", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                ]
              ]))
            ]
          ),
          children: matches.expand<Widget>((id) => [
            ListTileTheme(
              tileColor: Get.theme.listTileTheme.tileColor,
              child: controller.pronostiek!.matches[id]!.getListTile(controller, controller.textControllers[id]!, pastDeadline)
            ),
            const Divider(),
          ]).toList(),
        )
      );
    }).toList();
  }

  Widget getProgressionCard(String title, List<String?> teamIds, int crossAxisCount, PronostiekController controller, int pageIdx, {bool disable=false}) {
    int mainAxisCount = (teamIds.length/crossAxisCount).round();
    return Card(child: SingleChildScrollView(child: Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,),
      const Divider(),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(mainAxisCount, (i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(crossAxisCount, (j) {
              return Container(margin: const EdgeInsets.symmetric(vertical: 5), child: SizedBox(width: Get.theme.textTheme.bodyText2!.fontSize!*3*0.8+30+16+5,child: OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(8.0)
                  ),
                ),
                onPressed: (disable || controller.progressionPageIdx != pageIdx)? null : (teamIds[i*crossAxisCount+j] != null ? () => controller.removeTeamFromProgression(teamIds[i*crossAxisCount+j]!) : null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (teamIds[i*crossAxisCount+j] != null) ...[
                      Get.find<MatchController>().teams[teamIds[i*crossAxisCount+j]]!.getFlag(),
                    ],
                    const VerticalDivider(thickness: 0, width: 5,),
                    Text(Get.find<MatchController>().teams[teamIds[i*crossAxisCount+j]]?.shortName ?? ""),
                  ]
                ),
              )));
            })
          );
        })
      ),
    ],)));
  }

}