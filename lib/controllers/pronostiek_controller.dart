import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/api/time_client.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';

class PronostiekController extends GetxController {
  Pronostiek? pronostiek;
  Repository repo = Get.find<Repository>();
  /// index of shown tab
  var tabIndex = 0;
  List<String> matchIds = [];
  List<MatchGroup> groups = [];

  Map<String,MatchGroup> deadlines = {};
  DateTime deadlineRandom = DateTime.utc(2022,11,20, 16, 00);
  DateTime deadlineProgression = DateTime.utc(2022,11,20, 16, 00);

  late DateTime utcTime;
  TimeClient timeClient = Get.find<TimeClient>();

  List<bool> matchGroupCollapsed = [];
  Map<String,List<TextEditingController>> textControllers = {};
  List<TextEditingController> textControllersRandom = [];
  PageController progressionController = PageController(viewportFraction: min(500/Get.width, 1.0), initialPage: 1);
  int progressionPageIdx = 1;
  int nFilledInProgression = 0;
  ScrollController scroll = ScrollController();
  final randomFormKey = GlobalKey<FormState>();

  @override
  onClose() {
    for (String key in textControllers.keys) {
      textControllers[key]![0].dispose();
      textControllers[key]![1].dispose();
    }
    for (TextEditingController controller in textControllersRandom) {
      controller.dispose();
    }
    super.onClose();
  }

  PronostiekController() {
    List<String> groupMatchesIds = ["A1","A2","A3","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6"];
    // ignore: non_constant_identifier_names
    List<String> R16MatchesIds = ["R16A","R16B","R16C","R16D","R16E","R16F","R16G","R16H"];
    // ignore: non_constant_identifier_names
    List<String> QFMatchesIds = ["QF1","QF2","QF3","QF4"];
    // ignore: non_constant_identifier_names
    List<String> SFMatchesIds = ["SF1", "SF2"];
    // ignore: non_constant_identifier_names
    List<String> FMatchesIds = ["F", "f"];
    MatchGroup groupMatches = MatchGroup("Group Phase", DateTime.utc(2022,11,20, 16, 00));
    // ignore: non_constant_identifier_names
    MatchGroup R16Matches = MatchGroup("Round of 16", DateTime.utc(2022,12, 3, 15, 00));
    // ignore: non_constant_identifier_names
    MatchGroup QFMatches = MatchGroup("Quarter Finals", DateTime.utc(2022,12, 9, 15, 00));
    // ignore: non_constant_identifier_names
    MatchGroup SFMatches = MatchGroup("Semi Finals", DateTime.utc(2022,12,13, 19, 00));
    // ignore: non_constant_identifier_names
    MatchGroup FMatches = MatchGroup("Finals", DateTime.utc(2022,12,17, 19, 00));
    matchIds.addAll(groupMatchesIds);
    for (String id in groupMatchesIds) {deadlines[id] = groupMatches;}
    groups.add(groupMatches);

    matchIds.addAll(R16MatchesIds);
    for (String id in R16MatchesIds) {deadlines[id] = R16Matches;}
    groups.add(R16Matches);

    matchIds.addAll(QFMatchesIds);
    for (String id in QFMatchesIds) {deadlines[id] = QFMatches;}
    groups.add(QFMatches);

    matchIds.addAll(SFMatchesIds);
    for (String id in SFMatchesIds) {deadlines[id] = SFMatches;}
    groups.add(SFMatches);

    matchIds.addAll(FMatchesIds);
    for (String id in FMatchesIds) {deadlines[id] = FMatches;}
    groups.add(FMatches);

    for (MatchGroup _ in groups) {matchGroupCollapsed.add(true);}
  }

  void setUtcTime({bool update=true}) {
    List<DateTime> deadlines = this.deadlines.values.map((MatchGroup e) => e.deadline).toList() + [deadlineProgression, deadlineRandom];
    timeClient.getTime().then((time) {
      utcTime = time;
      DateTime? closestDeadline = deadlines.fold(null, (v, e) {
        if (time.isAfter(e)) {return v;}
        if (v == null) {return e;}
        if (v.isAfter(e)) {return e;}
        return v;
      });
      if (closestDeadline != null) {
        Duration timeUntilNextCall = closestDeadline.difference(time) < const Duration(minutes: 30) ? closestDeadline.difference(time) : const Duration(minutes: 30);
        print("Created future with difference $timeUntilNextCall");
        Future.delayed(timeUntilNextCall, () => setUtcTime());
      }
      if (update) {this.update();}
    });
  }


  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  void calcNFilledInProgression() {
    int filledIn = 0;
    filledIn += pronostiek!.progression.round16.fold(0, (v,e) => e != null ? v+1 : v);
    filledIn += pronostiek!.progression.quarterFinals.fold(0, (v,e) => e != null ? v+1 : v);
    filledIn += pronostiek!.progression.semiFinals.fold(0, (v,e) => e != null ? v+1 : v);
    filledIn += pronostiek!.progression.wcFinal.fold(0, (v,e) => e != null ? v+1 : v);
    filledIn += pronostiek!.progression.winner != null ? 1 : 0;
    nFilledInProgression = filledIn;
  }

  Future<void> initPronostiek() async {
    utcTime = await timeClient.getTime();
    setUtcTime(update: false);
    repo.getPronostiek().then((pronostiek) {
      this.pronostiek = pronostiek;
      for (var element in matchIds) {textControllers[element] = [TextEditingController(text: pronostiek!.matches[element]?.goalsHomeFT?.toString() ?? ""),TextEditingController(text: pronostiek.matches[element]!.goalsAwayFT?.toString() ?? "")];}
      for (RandomPronostiek element in pronostiek!.random) {textControllersRandom.add(TextEditingController(text: element.answer ?? ""));}
      calcNFilledInProgression();
      update();
    });
  }

  void save() async {
    for (var element in matchIds) {
      pronostiek!.matches[element]!.goalsHomeFT = int.tryParse(textControllers[element]?.first.text ?? "");
      pronostiek!.matches[element]!.goalsAwayFT = int.tryParse(textControllers[element]?.last.text ?? "");
    }
    for (int i=0; i<pronostiek!.random.length; i++) {
      pronostiek!.random[i].answer = textControllersRandom[i].text == "" ? null : textControllersRandom[i].text;
    }
    bool success = await repo.savePronostiek(pronostiek!);
    if (success) {
      Get.snackbar("Your changes were saved", "The changes to your pronostiek were succesfully save to the server", colorText: Colors.white);
    }
    initPronostiek();
  }

  void toggleGroupCollapse(int index) {
    matchGroupCollapsed[index] = !matchGroupCollapsed[index]; 
    update();
  }

  void updateProgressionPageIdx(int idx, {bool animate=true}) {
    if (idx < 0) {
      idx = 0;
    }
    if (idx > 5) {
      idx = 5;
    }
    progressionPageIdx = idx;
    if (animate) {
      progressionController.animateToPage(idx, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
    update();
  }

  void addTeamToProgression(String teamId) {
    switch (progressionPageIdx-1) {
      case 0:
        int insertIdx = pronostiek!.progression.round16.indexOf(null);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.round16[insertIdx] = teamId;
        break;
      case 1:
        int insertIdx = pronostiek!.progression.quarterFinals.indexOf(null);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.quarterFinals[insertIdx] = teamId;
        break;
      case 2:
        int insertIdx = pronostiek!.progression.semiFinals.indexOf(null);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.semiFinals[insertIdx] = teamId;
        break;
      case 3:
        int insertIdx = pronostiek!.progression.wcFinal.indexOf(null);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.wcFinal[insertIdx] = teamId;
        break;
      case 4:
        if (pronostiek!.progression.winner != null) {return;}
        pronostiek!.progression.winner = teamId;
        break;
      default:
      return;
    }
    update();
  }

  void removeTeamFromProgression(String teamId) {
    switch (progressionPageIdx-1) {
      case 0:
        int insertIdx = pronostiek!.progression.round16.indexOf(teamId);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.round16[insertIdx] = null;
        break;
      case 1:
        int insertIdx = pronostiek!.progression.quarterFinals.indexOf(teamId);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.quarterFinals[insertIdx] = null;
        break;
      case 2:
        int insertIdx = pronostiek!.progression.semiFinals.indexOf(teamId);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.semiFinals[insertIdx] = null;
        break;
      case 3:
        int insertIdx = pronostiek!.progression.wcFinal.indexOf(teamId);
        if (insertIdx == -1) {return;}
        pronostiek!.progression.wcFinal[insertIdx] = null;
        break;
      case 4:
        if (pronostiek!.progression.winner != teamId) {return;}
        pronostiek!.progression.winner = null;
        break;
      default:
      return;
    }
    update();
  }

  bool teamInProgression(String teamId) {
    switch (progressionPageIdx-1) {
      case -1:
      return true;
      case 0:
        return pronostiek!.progression.round16.contains(teamId);
      case 1:
        return pronostiek!.progression.quarterFinals.contains(teamId);
      case 2:
        return pronostiek!.progression.semiFinals.contains(teamId);
      case 3:
        return pronostiek!.progression.wcFinal.contains(teamId);
      case 4:
        return pronostiek!.progression.winner == teamId;
      default:
      return false;
    }  
  }

  updateMatchWinner(bool? value, String matchId) {
    pronostiek!.matches[matchId]!.winner = value;
    // update();
  }

}
