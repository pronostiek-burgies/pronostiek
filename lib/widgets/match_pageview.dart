import 'dart:math';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/pages/match_page.dart';

class MatchPageView extends StatelessWidget {
  PageController pageController = PageController(viewportFraction: min(250/Get.size.width,1.0),);
  
  MatchPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        List<Match> sortedMatches = controller.matches.values.toList();
        sortedMatches.sort((a,b) => a.startDateTime.compareTo(b.startDateTime));
        int indexFirstActiveGame = sortedMatches.indexWhere((element) => element.isBusy() || element.startDateTime.isAfter(controller.utcTime));
        if (pageController.hasClients) {
          pageController.animateToPage(indexFirstActiveGame, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
        }
        return Row(
          children: [
            IconButton(
              onPressed: () {pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);},
              icon: const Icon(Icons.chevron_left)
            ),
            Flexible(child:LayoutBuilder(
              builder: (context, boxConstraints) {
                pageController = PageController(viewportFraction: min(250/boxConstraints.maxWidth, 1.0));
                return ExpandablePageView(
                // onPageChanged: (int page) {pageController.animateToPage(page, duration: const Duration(seconds: 1), curve: Curves.easeInOut);},
                  controller: pageController,
                  children: sortedMatches.map<Widget>((Match match) {
                    return GestureDetector(
                      onTap: () => Get.to(() => MatchPage(match.id)),
                      child: Card(
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
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(match.home?.name ?? match.linkHome!, overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                                const Divider(thickness: 1.0, height:5.0),
                                Row(
                                  children: [
                                    if (match.away != null) ...[
                                      match.away!.getFlag(),
                                    ],
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(match.away?.name ?? match.linkAway!, overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (match.status == MatchStatus.notStarted) ...[
                                    Text(DateFormat("dd/MM").format(match.startDateTime.toLocal()), textAlign: TextAlign.center,),
                                    Text(DateFormat("HH:mm").format(match.startDateTime.toLocal()), textAlign: TextAlign.center,),
                                  ] else if (match.status == MatchStatus.ended) ...[
                                    Text(match.goalsHomeOT != null ? "FT\n(+OT)" : "FT", textAlign: TextAlign.center,),
                                  ] else ...[
                                    Text(match.timeToString()),
                                  ],
                                ],
                              ),
                            ),
                            if (match.status == MatchStatus.ended || match.isBusy()) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Text("${match.goalsHomeOT ?? match.goalsHomeFT!} ${match.goalsHomePen != null ? "(${match.goalsHomePen})": ""}"),
                                      Text("${match.goalsAwayOT ?? match.goalsAwayFT!} ${match.goalsAwayPen != null ? "(${match.goalsAwayPen})": ""}"),
                                    ]
                                ),
                              ),                     
                            ],
                          ],
                        )),
                      )
                    ));
                  }).toList(),
                );
              }
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
  