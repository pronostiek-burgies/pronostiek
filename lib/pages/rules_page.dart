import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';

class RulesPage extends StatelessWidget {
  final Widget drawer;
  RulesPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Pronostiek WK Qatar"),
        // actions: <Widget>[
        // ],
      ),
      body: DefaultTextStyle(style: Get.textTheme.bodyMedium!, textAlign: TextAlign.start, child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.size.width*0.1),
        child:  SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Rules", style: Get.textTheme.headlineLarge),
            const Text("Welcome to the only burgie worthy pronostiek, with point distribution based on mathemethics and Brent's opinion.\n"),
            Text("1. Matches", style: Get.textTheme.headlineMedium),
            const Text("Points for matches are calculates as follows:"),
            const Text.rich(textAlign: TextAlign.start, TextSpan(children: [
              TextSpan(text: "Points", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " = floor(("),
              TextSpan(text: "Base Points", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " + "),
              TextSpan(text: "Bonus Points", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ") x "),
              TextSpan(text: "Mulitplier", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " )\n"),
            ])),
            Text("1.1. Multiplier", style: Get.textTheme.headlineSmall),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Multiplier ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "depends on the type of match:"),
            ])),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Match Type',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Multiplier',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Group Match')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.group]!.toStringAsFixed(1))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Round of 16')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.roundOf16]!.toStringAsFixed(1))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Quarter Finals')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.quarterFinals]!.toStringAsFixed(1))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Semi-Finals')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.semiFinals]!.toStringAsFixed(1))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Final')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.wcFinal]!.toStringAsFixed(1))),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Loser Final')),
                    DataCell(Text(MatchPronostiek.matchTypeMultiplier[MatchType.bronzeFinal]!.toStringAsFixed(1))),
                  ],
                ),
              ],
            ),
            Text("1.2. Base Points", style: Get.textTheme.headlineSmall),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Base Points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " are earned when you predict the correct winner (or draw):"),
            ])),
            const Text.rich(TextSpan(children: [
              TextSpan(text:"\t- For "),
              TextSpan(text: "group matches", style: TextStyle(decoration: TextDecoration.underline)),
              TextSpan(text: " you earn "),
              TextSpan(text: "${MatchPronostiek.basePointsWin} points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "for predicting the correct winner and "),
              TextSpan(text: "${MatchPronostiek.basePointsDraw} points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " for predicting a draw."),
            ])),
            const Text.rich(TextSpan(children: [
              TextSpan(text:"\t- For "),
              TextSpan(text: "knock-out matches", style: TextStyle(decoration: TextDecoration.underline)),
              TextSpan(text: " you earn "),
              TextSpan(text: "${MatchPronostiek.basePointsWin} points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "for predicting the correct winner after 90'. If you correctly predict a draw after 90' you will earn "),
              TextSpan(text: "${MatchPronostiek.basePointsDrawKnockout} points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "and if you also predict the correct winner after extra time/penalties you will earn "),
              TextSpan(text: "${MatchPronostiek.basePointsDrawKnockoutWinner} points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "extra.\n"),
            ])),
            
            Text("1.3. Bonus Points", style: Get.textTheme.headlineSmall),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Bonus Points ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "are earned for predicting the correct (or being close to the correct) score after 90'. Bonus points for rare scores are higher than for normal scores:"),
            ])),
            Image.asset("assets/bonus_points_eq.png", scale:1.75, alignment: Alignment.centerLeft,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(
              children: [
                const Text("With "),
                Image.asset("assets/P_single_team.png", scale:1.75),
                const Text(" :"),
              ],
            )),
            DataTable(
              columnSpacing: 4.0,
              columns: <DataColumn>[
                const DataColumn(
                  label: Expanded(
                    child: Text(
                      'Goals',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const DataColumn(label: VerticalDivider()),
                ...List.generate(10, (i) => DataColumn(
                  label: Expanded(
                    child: Text(i.toString()),
                    ),
                  ),
                ).toList(),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Points', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataCell(VerticalDivider()),
                    ...List.generate(10, (i) =>
                      DataCell(Text(MatchPronostiek.bonusPointsGoalsSingleTeam[i].toString()))
                    ).toList(),
                  ],
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(
              children: [
                const Text("With "),
                Image.asset("assets/P_both_teams.png", scale:1.75),
                const Text(" :"),
              ],
            )),
            DataTable(
              columnSpacing: 4.0,
              columns: <DataColumn>[
                const DataColumn(
                  label: Expanded(
                    child: Text(
                      'Goals',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const DataColumn(label: VerticalDivider()),
                ...List.generate(10, (i) => DataColumn(
                  label: Expanded(
                    child: Text(i.toString()),
                    ),
                  ),
                ).toList(),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Goals', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataCell(VerticalDivider()),
                    ...List.generate(10, (i) =>
                      DataCell(Text(MatchPronostiek.bonusPointsTotalGoals[i].toString()))
                    ).toList(),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Points', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataCell(VerticalDivider()),
                    ...List.generate(10, (i) =>
                      DataCell(Text((i+10).toString(), style: const TextStyle(fontWeight: FontWeight.bold),))
                    ).toList(),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Points', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataCell(VerticalDivider()),
                    ...List.generate(10, (i) =>
                      DataCell(Text(MatchPronostiek.bonusPointsTotalGoals[i+10].toString()))
                    ).toList(),
                  ],
                ),
              ],
            ),
            const Text("With:"),
            Image.asset("assets/delta_factor.png", scale:1.25, alignment: Alignment.centerLeft,),
            const Text("Where:"),
            Text.rich(TextSpan(children: [
              const TextSpan(text: "\t\t- "),
              WidgetSpan(child:Image.asset("assets/saldo_predict.png", scale:2)),
              const TextSpan(text: " and "),
              WidgetSpan(child:Image.asset("assets/total_predict.png", scale:2)),
              const TextSpan(text: " are respectively absolute the goal difference and the total goals of your predicted score."),
            ])),
            Text.rich(TextSpan(children: [
              const TextSpan(text: "\t\t- "),
              WidgetSpan(child:Image.asset("assets/delta_saldo.png", scale:2)),
              const TextSpan(text: " and "),
              WidgetSpan(child:Image.asset("assets/delta_total.png", scale:2)),
              const TextSpan(text: " are respectively the difference between the goal difference of your predicted score and the correct score and the difference between the total goals of your predicted score and the correct score.\n"),
            ])),
            
            const Text("The pronostiek for the matches need to be filled in before the first match of the tournament stage:"),
            const Text("Deadlines", style:TextStyle(fontWeight: FontWeight.bold)),
            const Text("\t- Group Phase: 20/11 17:00"),
            const Text("\t- Round of 16: 03/12 16:00"),
            const Text("\t- Quarter Finals: 09/12 16:00"),
            const Text("\t- Semi Finals: 13/12 20:00"),
            const Text("\t- Finals: 17/12 20:00\n"),

            Text("2. Progression", style: Get.textTheme.headlineMedium),
            const Text("""Predict for each round which teams will progress to the next tournament stage. You do not need to predict which teams play against each other.  
You can also fill in a not logical prediction (e.g. Brazil wins the World Cup, Argentina and Germany play the Final."""),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "- Predict which 16 teams will compete in the"),
              TextSpan(text:" ("),
              TextSpan(text: "Round of 16 ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:"2 pts", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "/correct team)"),
            ])), 
            const Text.rich(TextSpan(children: [
              TextSpan(text: "- Predict which 8 teams will compete in the"),
              TextSpan(text:" ("),
              TextSpan(text: "Quarter Finals ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:"5 pts", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "/correct team)"),
            ])), 
            const Text.rich(TextSpan(children: [
              TextSpan(text: "- Predict which 4 teams will compete in the"),
              TextSpan(text:" ("),
              TextSpan(text: "Semi Finals ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:"10 pts", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "/correct team)"),
            ])), 
            const Text.rich(TextSpan(children: [
              TextSpan(text: "- Predict which 2 teams will compete in the"),
              TextSpan(text:" ("),
              TextSpan(text: "World Cup Final ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:"20 pts", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "/correct team)"),
            ])), 
            const Text.rich(TextSpan(children: [
              TextSpan(text: "- Predict which team will"),
              TextSpan(text:" ("),
              TextSpan(text: "win the World Cup ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:"50 pts", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "/correct team)\n"),
            ])),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Deadline", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ": 20/11 17:00\n"),
            ])), 

            Text("3. Random Questions", style: Get.textTheme.headlineMedium),
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Anwser some random Questions about this World Cup, each question is worth "),
              TextSpan(text: "20 points ", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ". If the answer is a number you get 20 points if you are the closest to the correct answer.\n"),
            ])), 
            const Text.rich(TextSpan(children: [
              TextSpan(text: "Deadline", style:TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ": 20/11 17:00\n"),
            ])), 

            Text("General Info", style: Get.textTheme.headlineLarge),
            const Text("The fractions in the top left of every purple bar show how many item of your pronostiek are saved on the server. So when you fill in your pronostiek make sure to save your changes and check if the fractions have changed accordingly.\n"),
            Image.asset("assets/fractions.png"),
            const Text("\nIf you need a refresher of the calculation of the match points you can alway tap the '?' to get info about how the points are calculated.\n"),
            Image.asset("assets/help.png"),

            const Text("The algorithm to calculate the points was tuned using more 25000 match scores. Some statistics of the distribution of the points together with a comparison to the Sporza WK pronostiek is shown below.\n"),
            GestureDetector(
              onTap: () => Get.defaultDialog(title: "Point statistics",
                content: SizedBox(
                  height: Get.size.aspectRatio < 1 ? Get.size.height/2 : null,
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 5,
                    child: Image.asset("assets/stats.png"),
                  )
                ),
              ),
              child: Image.asset("assets/stats.png")
            ),
            

            const Text("\n\n"),
          ],
        ),
      ))
    ));
  }

}