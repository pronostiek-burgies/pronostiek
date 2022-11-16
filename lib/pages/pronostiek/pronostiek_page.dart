import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/controllers/pronostiek_page_controller.dart';
import 'package:pronostiek/controllers/result_controller.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_matches.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_progression.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_random.dart';

class PronostiekPage extends StatelessWidget {
  final Widget drawer;
  const PronostiekPage(this.drawer, {super.key});

    static Widget pronostiekHeaderMatchGroup(
    String title,
    DateTime deadline,
    int nToFillIn,
    int filledIn,
    bool pastDeadline,
    int? points,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(color: Colors.white),)),
        Row(mainAxisAlignment:MainAxisAlignment.center, children: [
          Icon(pastDeadline ? Icons.event_busy : Icons.event_available, color: Colors.white),
          const VerticalDivider(),
          Text(DateFormat('dd/MM kk:mm').format(deadline.toLocal()), style: const TextStyle(color: Colors.white),),
        ],),
        Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text("$filledIn/$nToFillIn", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,),
          if (pastDeadline) ...[
            const VerticalDivider(),
            Text("Pts: $points", style: const TextStyle(color: Colors.white), textAlign: TextAlign.end,),
          ]
        ]))
      ]
    );
  }

  static Widget pronostiekHeader(
    String title,
    DateTime deadline,
    int nToFillIn,
    int filledIn,
    bool pastDeadline,
    int? points,
  ) => ListTile(
    tileColor: wcPurple[800],
    title: pronostiekHeaderMatchGroup(title, deadline, nToFillIn, filledIn, pastDeadline, points)
  );
 
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekPageController>(
      builder: (controller) => Scaffold(
        drawer: drawer,
        appBar: AppBar(
          title: const Text("Pronostiek WK Qatar"),
          actions: <Widget>[
            IconButton(onPressed: () => Get.find<PronostiekController>().save(), icon: const Icon(Icons.save)),
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
        body: IndexedStack(
          index: controller.tabIndex,
          children: [
            Visibility(maintainState: true, visible: controller.tabIndex==0,child: const PronostiekMatches()),
            Visibility(maintainState: true, visible: controller.tabIndex==1,child: const PronostiekProgression()),
            Visibility(maintainState: false, visible: controller.tabIndex==2,child: const PronostiekRandom()),
          ],
        ),
      )
    );
  }






}