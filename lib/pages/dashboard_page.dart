import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_background.dart';
import 'package:pronostiek/colors.dart/wc_orange.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
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
            Container(
              margin: const EdgeInsets.all(10),
              color: Get.theme.cardColor,
              height: controller.usernames.length*100.0,
              child: charts.BarChart(
                getRankingData(controller.usernames),
                animate: true,
                behaviors: [charts.SeriesLegend()],
                barGroupingType: charts.BarGroupingType.stacked,
                vertical: false,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  showAxisLine: true,
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

List<charts.Series<UserPoints, String>> getRankingData(List<String> usernames) {
  List<UserPoints> matchPoints = usernames.map<UserPoints>((username) => UserPoints(username, 10)).toList();
  List<UserPoints> progressionPoints = usernames.map<UserPoints>((username) => UserPoints(username, 10)).toList();
  List<UserPoints> randomPoints = usernames.map<UserPoints>((username) => UserPoints(username, 10)).toList();
  List<UserPoints> total = [matchPoints, progressionPoints, randomPoints]
  .reduce((List<UserPoints> v, List<UserPoints> e) => v
  .map((userPoints) => userPoints.addPoints(e.firstWhere((element) => userPoints.username == element.username).points)).toList());
  
   return [
    charts.Series<UserPoints, String>(
      id: 'Matches',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: matchPoints,
      labelAccessorFn: (UserPoints e, _) => e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcRed),
    ),
    charts.Series<UserPoints, String>(
      id: 'Progression',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: progressionPoints,
      labelAccessorFn: (UserPoints e, _) => e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcPurple),
    ),
    charts.Series<UserPoints, String>(
      id: 'Random',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: randomPoints,
      labelAccessorFn: (UserPoints e, _) => e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcOrange),
    ),
    charts.Series<UserPoints, String>(
      id: '',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => 0,
      data: total,
      labelAccessorFn: (UserPoints e, _) => e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(Get.theme.cardColor),
    ),
  ];
}


class UserPoints {
  final String username;
  final int points;

  UserPoints addPoints(int points) {
    return UserPoints(username, this.points + points);
  }

  UserPoints(this.username, this.points);
}

