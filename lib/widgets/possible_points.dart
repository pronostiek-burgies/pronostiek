
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';



class PossiblePointsWidget extends StatelessWidget {
  int? goalsHome;
  int? goalsAway;
  Match match;
  
  PossiblePointsWidget(this.goalsHome, this.goalsAway, this.match, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pair<String,int>>? points;
    if (goalsHome != null && goalsAway != null) {
      points = List.generate(100, (index) {
        int home = (index/10).floor();
        int away = index%10;
        return Pair("$home - $away", MatchPronostiek.getBonusPoints(home, away, goalsHome!, goalsAway!));
      });
      points = points.where((element) => element.last > 0).toList();
      points.sort((b, a) => a.last.compareTo(b.last));
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("For this ${match.knockout ? "knockout": "group"} match your points are calculated as followed:"),
        Text.rich(TextSpan(children: [
          const TextSpan(text: "Points = floor( ( "),
          const TextSpan(text: "Base Points",style: TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: " + "),
          const TextSpan(text: "Bonus Points",style: TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: " ) x "),
          TextSpan(text: MatchPronostiek.matchTypeMultiplier[match.type]!.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: " )"),
        ])),
        if (points != null) ...[
          Text("Below you see how many bonus points you will receive\nfor your current prediction ($goalsHome-$goalsAway) for a given match result."),
          Flexible(child:SingleChildScrollView(scrollDirection: Axis.horizontal ,child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  _buildTableCell("Match Result", [false,true,false,true], width: 120),
                  _buildTableCell("Bonus Points", [true,false,false,true], width: 120),
                ],
              ),
              ... points.map<Widget>((e) => Column(
                children: [
                  _buildTableCell(e.first, [false,true,true,e != points!.last]),
                  _buildTableCell(e.last.toString(), [true, false,true,e!= points.last]),
                ],
              )),
            ],
          )))
        ]
      ]
    );
  }

  Widget _buildTableCell(String text, List<bool> borders, {double width=60}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          top: borders[0] ? const BorderSide() : BorderSide.none,
          bottom: borders[1] ? const BorderSide() : BorderSide.none,
          left:  borders[2] ? const BorderSide() : BorderSide.none,
          right:  borders[3] ? const BorderSide() : BorderSide.none,
        )
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4.0),
      child: Text(text, textAlign: TextAlign.center,),
    );
  }
}

class Pair<T1, T2> {
  final T1 first;
  final T2 last;

  Pair(this.first, this.last);
}


