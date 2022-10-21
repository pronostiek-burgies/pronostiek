import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/dashboard_controller.dart';
import 'package:pronostiek/widgets/match_pageview.dart';

class DashboardPage extends StatelessWidget {
  final Widget drawer;
  
  const DashboardPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Pronostiek WK Qatar"),
        // actions: <Widget>[
        // ],
      ),
      body: GetBuilder<DashboardController>(
        builder: (controller) => Column(
          children: [
            const Text("Matches", textScaleFactor: 2.0, style: TextStyle(fontWeight: FontWeight.bold),),
            MatchPageView(),
            const Text("Ranking", textScaleFactor: 2.0, style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(
              height: controller.usernames.length*100.0,
              child: charts.BarChart(
                getRankingData(controller.usernames),
                animate: true,
                barGroupingType: charts.BarGroupingType.stacked,
                vertical: false,
              )
            )
          ],
        ),
      )
    );
  }
}

List<charts.Series<UserPoints, String>> getRankingData(List<String> usernames) {
  List<UserPoints> matchPoints = usernames.map<UserPoints>((username) => UserPoints(username, 0)).toList();
  List<UserPoints> progressionPoints = usernames.map<UserPoints>((username) => UserPoints(username, 0)).toList();
  List<UserPoints> randomPoints = usernames.map<UserPoints>((username) => UserPoints(username, 0)).toList();

   return [
    charts.Series<UserPoints, String>(
      id: 'Matches',
      domainFn: (UserPoints sales, _) => sales.username,
      measureFn: (UserPoints sales, _) => sales.points,
      data: matchPoints,
    ),
    charts.Series<UserPoints, String>(
      id: 'Progression',
      domainFn: (UserPoints sales, _) => sales.username,
      measureFn: (UserPoints sales, _) => sales.points,
      data: progressionPoints,
    ),
    charts.Series<UserPoints, String>(
      id: 'Random',
      domainFn: (UserPoints sales, _) => sales.username,
      measureFn: (UserPoints sales, _) => sales.points,
      data: randomPoints,
    ),
  ];
}


class UserPoints {
  final String username;
  final int points;

  UserPoints(this.username, this.points);
}