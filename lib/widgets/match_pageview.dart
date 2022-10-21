import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/match.dart';

class MatchPageView extends StatelessWidget {
  final pageController = PageController(viewportFraction: min(300/Get.size.width,1.0),);
  
  MatchPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        List<Match> sortedMatches = controller.matches.values.toList();
        sortedMatches.sort((a,b) => a.startDateTime.compareTo(b.startDateTime));
        int indexFirstActiveGame = sortedMatches.indexWhere((element) => element.isBusy() || element.startDateTime.isAfter(controller.utcTime));
        print(indexFirstActiveGame);
        if (pageController.hasClients) {
          pageController.animateToPage(indexFirstActiveGame, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
        }
        return Row(
          children: [
            IconButton(
              onPressed: () {pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);},
              icon: const Icon(Icons.chevron_left)
            ),
            Flexible(child:ExpandablePageView(
              // onPageChanged: (int page) {pageController.animateToPage(page, duration: const Duration(seconds: 1), curve: Curves.easeInOut);},
              controller: pageController,
              children: sortedMatches.map<Card>((Match match) {
                return Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: IntrinsicHeight(child: Row(
                      children: [
                        Expanded(child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (match.home != null) ...[
                                  match.home!.getFlag(),
                                ],
                                const VerticalDivider(width: 8),
                                Text(match.home?.name ?? match.linkHome!),
                              ],
                            ),
                            const Divider(thickness: 1.0, height:5.0),
                            Row(
                              children: [
                                if (match.away != null) ...[
                                  match.away!.getFlag(),
                                ],
                                const VerticalDivider(width: 8),
                                Text(match.away?.name ?? match.linkAway!),
                              ],
                            ),
                          ],
                        )),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (match.status == MatchStatus.notStarted) ...[
                                Text(DateFormat("dd/MM").format(match.startDateTime.toLocal())),
                                Text(DateFormat("HH:mm").format(match.startDateTime.toLocal())),
                              ] else if (match.status == MatchStatus.ended) ...[
                                Text(match.goalsHomeOT != null ? "FT\n(+OT)" : "FT", textAlign: TextAlign.center,),
                              ] else ...[
                                Text("${match.time}'")
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (match.status == MatchStatus.ended || match.isBusy()) ...[
                                Text("${match.goalsHomePen != null ? "(${match.goalsHomePen})": ""} ${match.goalsHomeOT ?? match.goalsHomeFT!}"),
                                Text("${match.goalsAwayPen != null ? "(${match.goalsAwayPen})": ""} ${match.goalsHomeOT ?? match.goalsHomeFT!}"),
                              ]
                            ],
                          ),
                        ),                     
                      ],
                    )),
                  )
                );
              }).toList(),
            )),
            IconButton(
              onPressed: () {pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);},
              icon: const Icon(Icons.chevron_right)
            ),
          ],

        );
      }
    );
  }
}
  