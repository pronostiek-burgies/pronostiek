import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/colors.dart/wc_background.dart';
import 'package:pronostiek/colors.dart/wc_orange.dart';
import 'package:pronostiek/colors.dart/wc_purple.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/result_controller.dart';
import 'package:pronostiek/models/user.dart';
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
          actions: <Widget>[
            IconButton(
                onPressed: () => Get.find<ResultController>().refreshSolution(),
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: GetBuilder<ResultController>(builder: (controller) {
          PointsPerDayWrapper? evolution = getEvolutionData(controller);
          return SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Matches",
                  textScaleFactor: 2.0,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                MatchPageView(),
                const Text(
                  "Ranking",
                  textScaleFactor: 2.0,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                !controller.initialized
                    ? const CircularProgressIndicator()
                    : Container(
                        margin: const EdgeInsets.all(10),
                        color: Get.theme.cardColor,
                        height: controller.usernames.length * 100.0,
                        child: Row(children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 35),
                                // const SizedBox(height: 21,),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...controller.users.values
                                      .map((User e) => Flexible(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                          e.getProfilePicture(),
                                          SizedBox(width: 64, child: Text(e.username, textAlign: TextAlign.center, textScaleFactor: 0.75, maxLines: 2, overflow: TextOverflow.ellipsis,))
                                        ])
                                      ))
                                      .toList(),
                                  ]
                                )),
                                // const SizedBox(height: 0),
                                const SizedBox(height: 28),
                              ]),
                          Expanded(
                              child: charts.BarChart(
                            getRankingData(controller),
                            layoutConfig: charts.LayoutConfig(
                                leftMarginSpec: charts.MarginSpec.fixedPixel(4),
                                topMarginSpec: charts.MarginSpec.defaultSpec,
                                rightMarginSpec: charts.MarginSpec.defaultSpec,
                                bottomMarginSpec: charts.MarginSpec.fixedPixel(28)),
                            animate: true,
                            behaviors: [charts.SeriesLegend()],
                            barGroupingType: charts.BarGroupingType.stacked,
                            vertical: false,
                            barRendererDecorator:
                                charts.BarLabelDecorator<String>(),
                            domainAxis: const charts.OrdinalAxisSpec(
                                renderSpec: charts.NoneRenderSpec()),
                            primaryMeasureAxis: const charts.NumericAxisSpec(
                              showAxisLine: true,
                            ),
                            defaultInteractions: false,
                          )),
                        ]),
                      ),
                const Text(
                  "Evolution",
                  textScaleFactor: 2.0,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                evolution == null
                    ? const CircularProgressIndicator()
                    : Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        color: Get.theme.cardColor,
                        height: controller.usernames.length * 100.0,
                        child: charts.LineChart(
                          evolution.data,
                          animate: true,
                          behaviors: [charts.SeriesLegend()],
                          primaryMeasureAxis: const charts.NumericAxisSpec(
                            showAxisLine: true,
                          ),
                          domainAxis: charts.NumericAxisSpec(
                              renderSpec: const charts.SmallTickRendererSpec(
                                labelRotation: 45,
                                labelAnchor: charts.TickLabelAnchor.inside,
                              ),
                              tickProviderSpec:
                                  charts.BasicNumericTickProviderSpec(
                                      desiredTickCount:
                                          evolution.domainTicks.length + 1,
                                      zeroBound: true),
                              tickFormatterSpec:
                                  charts.BasicNumericTickFormatterSpec((i) {
                                if (evolution.domainTicks[i!.toInt()] != null) {
                                  return evolution.domainTicks[i.toInt()]!;
                                } else {
                                  return "";
                                }
                              })),
                          defaultInteractions: false,
                          defaultRenderer:
                              charts.LineRendererConfig(includePoints: true),
                        ))
              ],
            ),
          );
        }));
  }
}

List<charts.Series<UserPoints, String>> getRankingData(
    ResultController controller) {
  List<UserPoints> matchPoints = controller
      .getAllMatchPoints()
      .map<String, UserPoints>((username, points) =>
          MapEntry(username, UserPoints(username, points)))
      .values
      .toList();
  List<UserPoints> progressionPoints = controller
      .getAllProgressionPoints()
      .map<String, UserPoints>((username, points) =>
          MapEntry(username, UserPoints(username, points)))
      .values
      .toList();
  List<UserPoints> randomPoints = controller
      .getAllRandomPoints()
      .map<String, UserPoints>((username, points) =>
          MapEntry(username, UserPoints(username, points)))
      .values
      .toList();
  List<UserPoints> total = [matchPoints, progressionPoints, randomPoints]
      .reduce((List<UserPoints> v, List<UserPoints> e) => v
          .map((userPoints) => userPoints.addPoints(e
              .firstWhere((element) => userPoints.username == element.username)
              .points))
          .toList());

  List<int> sortIndex =
      List.generate(controller.usernames.length, (index) => index);
  sortIndex.sort((b, a) => total[a].points.compareTo(total[b].points));
  Map<String, int> orderMap =
      total.asMap().map((k, v) => MapEntry(v.username, sortIndex[k]));

  matchPoints
      .sort((a, b) => orderMap[a.username]!.compareTo(orderMap[b.username]!));
  progressionPoints
      .sort((a, b) => orderMap[a.username]!.compareTo(orderMap[b.username]!));
  randomPoints
      .sort((a, b) => orderMap[a.username]!.compareTo(orderMap[b.username]!));

  return [
    charts.Series<UserPoints, String>(
      id: 'Matches',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: matchPoints,
      labelAccessorFn: (UserPoints e, _) =>
          e.points == 0 ? "" : e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcRed),
    ),
    charts.Series<UserPoints, String>(
      id: 'Progression',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: progressionPoints,
      labelAccessorFn: (UserPoints e, _) =>
          e.points == 0 ? "" : e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcPurple),
    ),
    charts.Series<UserPoints, String>(
      id: 'Random',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => e.points,
      data: randomPoints,
      labelAccessorFn: (UserPoints e, _) =>
          e.points == 0 ? "" : e.points.toString(),
      colorFn: (UserPoints e, _) => charts.ColorUtil.fromDartColor(wcOrange),
    ),
    charts.Series<UserPoints, String>(
      id: '',
      domainFn: (UserPoints e, _) => e.username,
      measureFn: (UserPoints e, _) => 0,
      data: total,
      labelAccessorFn: (UserPoints e, _) => e.points.toString(),
      colorFn: (UserPoints e, _) =>
          charts.ColorUtil.fromDartColor(Get.theme.cardColor),
    ),
  ];
}

PointsPerDayWrapper? getEvolutionData(ResultController controller) {
  if (controller.usernames.isEmpty) {
    return null;
  }
  Map<String, Map<DateTime, dynamic>> points = controller.getPointsPerDay(
      DateTime(2022, 11, 19), DateTime(2022, 12, 30),
      startZero: true);
  if (points.isEmpty) {
    return null;
  }
  List<DateTime> matchDays = points[controller.usernames[0]]!
      .keys
      .where(
        (element) => points[controller.usernames[0]]![element] != null,
      )
      .toList();
  matchDays.sort((a, b) => a.compareTo(b));
  Map<DateTime, int> matchDaysMap = matchDays.asMap().map<DateTime, int>(
        (key, value) => MapEntry(value, key),
      );
  return PointsPerDayWrapper(
      points.keys.map<charts.Series<PointsPerDay, int>>((key) {
        Map<DateTime, int> cumSomList = {};
        int cumSom = 0;
        for (DateTime date in points[key]!.keys) {
          cumSom += points[key]![date]![0] as int;
          cumSomList[date] = cumSom;
        }
        return charts.Series<PointsPerDay, int>(
          id: key,
          domainFn: (PointsPerDay e, _) => e.matchDay,
          measureFn: (PointsPerDay e, _) => e.points,
          colorFn: (PointsPerDay e, _) =>
              charts.ColorUtil.fromDartColor(controller.profileColors[key]!),
          data: points[key]!.entries.map<PointsPerDay>((e) {
            return PointsPerDay(matchDaysMap[e.key]!, cumSomList[e.key]!);
          }).toList(),
        );
      }).toList(),
      matchDays.asMap().map((key, value) =>
          MapEntry(key, points[controller.usernames[0]]![value][1])));
}

class PointsPerDayWrapper {
  List<charts.Series<PointsPerDay, int>> data;
  Map<int, String> domainTicks;

  PointsPerDayWrapper(this.data, this.domainTicks);
}

class PointsPerDay {
  final int matchDay;
  final int points;

  PointsPerDay(this.matchDay, this.points);
}

class UserPoints {
  final String username;
  final int points;

  UserPoints addPoints(int points) {
    return UserPoints(username, this.points + points);
  }

  UserPoints(this.username, this.points);
}
