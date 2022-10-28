import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/pages/result_pages/group_phase_page.dart';
import 'package:pronostiek/pages/result_pages/knockout_page.dart';

class ResultPage extends StatelessWidget {
  final Widget drawer;
  const ResultPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            title: const Text("Pronostiek WK Qatar"),
            actions: <Widget>[
              IconButton(onPressed: () => controller.updateAllMatches(), icon: const Icon(Icons.refresh))
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
                icon: Icon(Icons.format_list_numbered),
                label: 'Group Phase',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events),
                label: 'Knock-out',
              ),
              // NavigationDestination(
              //   icon: Icon(Icons.merge),
              //   label: 'Progression',
              // ),
              // NavigationDestination(
              //   icon: Icon(Icons.star),
              //   label: 'Random',
              // ),
            ]
          ),
          body: <Widget>[
            getMatches(controller),
            GroupPhasePage(controller),
            KnockoutPage(controller),
            // getKnockOut(controller),
            // getKnockOut(controller),
          ][controller.tabIndex],
        );
      }
    );
  }

  Widget getMatches(MatchController controller) {
    return ListView.builder(
      itemCount: controller.matches.length*2,
      itemBuilder: ((context, index) {
        List<String> keys = controller.getSortedKeys();
        return index%2 == 0 ? controller.matches[keys[index>>1]]!.getListTile() : const Divider();
      }),
    );
  }

  Widget getKnockOut(MatchController controller) {
    return const Text("Knock out");
  }


}