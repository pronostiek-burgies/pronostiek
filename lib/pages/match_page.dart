
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/controllers/result_controller.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/user.dart';

class MatchPage extends StatelessWidget {
  final String matchId;
  const MatchPage(this.matchId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Pronostiek WK Qatar"),
          ),
          body: GetBuilder<MatchController>(
            builder: (controller) {
              Match match = controller.matches[matchId]!;
              return Column(
                children: [
                  match.getListTile(openMatchPage: false),
                  if (controller.matches[matchId]!.isPastDeadline()) ...[
                    Flexible(child: getOtherPronostieks(match)),
                  ] else ...[
                    const Text("Pronostiek of other user not available. Wait for the deadline to pass.")
                  ]
                ],
              );
            },
          )
        );
      }
    );
  }

  Widget pronostiekToText(MatchPronostiek matchPronostiek, bool knockout) {
    if (matchPronostiek.goalsHomeFT == null || matchPronostiek.goalsAwayFT == null) {
      return const Text("/");
    }
    if (knockout && matchPronostiek.winner != null) {
      return RichText(text: TextSpan(
        children: [
          TextSpan(text: matchPronostiek.goalsHomeFT.toString(), style: matchPronostiek.winner! ? const TextStyle(decoration: TextDecoration.underline) : null),
          const TextSpan(text: "-"),
          TextSpan(text: matchPronostiek.goalsAwayFT.toString(), style: matchPronostiek.winner! ? null : const TextStyle(decoration: TextDecoration.underline)),
        ]
      ));
    } else {
      return Text("${matchPronostiek.goalsHomeFT}-${matchPronostiek.goalsAwayFT}");
    }
  }

  Widget getOtherPronostieks(Match match) {
    return GetBuilder<ResultController>(
      builder:(controller) {
        if (!controller.initialized) {
          return const CircularProgressIndicator();
        }
        List<String> usernames = controller.usernames;
        usernames.sort((b, a) {
          int pointsA = controller.pronostieks[a]!.matches[match.id]!.getPronostiekPoints(virtual: true) ?? 0;
          int pointsB = controller.pronostieks[b]!.matches[match.id]!.getPronostiekPoints(virtual: true) ?? 0;
          if (pointsA == pointsB) {
            int maxPointsA = controller.pronostieks[a]!.matches[match.id]!.getMaxPronostiekPoints() ?? 0;
            int maxPointsB = controller.pronostieks[b]!.matches[match.id]!.getMaxPronostiekPoints() ?? 0;
            return maxPointsA.compareTo(maxPointsB);
          } else {
            return pointsA.compareTo(pointsB);
          }
        });
        List<String> columns = ["Username", "Pronostiek", "Max possible score"];
        if (match.isBusy()) {
          columns.add("Virtual Points");
        } else if (match.status == MatchStatus.ended) {
          columns.add("Points Earned");
        }
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(thickness: 3.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(flex: 3, child: Text(columns[0], style: const TextStyle(fontWeight: FontWeight.bold))),
                    Flexible(flex: 1, child: Text(columns[1], style: const TextStyle(fontWeight: FontWeight.bold))),
                    Flexible(flex: 1,child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(flex: 1,child: Text(columns[2], style: const TextStyle(fontWeight: FontWeight.bold))),
                        if (match.status != MatchStatus.notStarted) ...[
                          Flexible(flex: 1,child: Text(columns[3], style: const TextStyle(fontWeight: FontWeight.bold))),
                        ]
                      ],
                    ),)
                  ],
                ),
              const Divider(thickness: 2.0,),
              ...usernames.expand<Widget>((String username) {
                return [
                  Flexible(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(flex: 3,child: Row(children: [controller.users[username]!.getProfilePicture(border: false),const SizedBox(width: 8.0,),Expanded(child:Text(username))])),
                      Flexible(flex: 1,child: pronostiekToText(controller.pronostieks[username]!.matches[match.id]!, match.knockout)),
                      Flexible(flex: 1,child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(flex: 1,child: Text(controller.pronostieks[username]!.matches[match.id]!.getMaxPronostiekPoints().toString())),
                          if (match.status != MatchStatus.notStarted) ...[
                            Flexible(flex: 1,child: Text(controller.pronostieks[username]!.matches[match.id]!.getPronostiekPoints(virtual: true).toString())),
                          ]
                        ],
                      ),)
                    ],
                  )),
                  const Divider(),
                ];
              })
            ]
        ));
      },
    );
  }

}