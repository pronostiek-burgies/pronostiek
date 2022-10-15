import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';

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
            // actions: <Widget>[
            // ],
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
                icon: Icon(Icons.merge),
                label: 'Knock-out',
              ),
            ]
          ),
          body: <Widget>[
            getMatches(controller),
            getGroupPhase(controller),
            getKnockOut(controller),
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
  Widget getGroupPhase(MatchController controller) {
    return const Text("Group Phase");
  }
  Widget getKnockOut(MatchController controller) {
    return const Text("Knock out");
  }


}