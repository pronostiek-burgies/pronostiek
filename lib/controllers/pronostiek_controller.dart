import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';

class PronostiekController extends GetxController {
  Pronostiek? pronostiek;
  Repository repo = Get.find<Repository>();
  /// index of shown tab
  var tabIndex = 0;
  Map<String,MatchGroup> dealines = {};
  List<String> matchIds = [];
  List<MatchGroup> groups = [];

  DateTime deadlineRandom = DateTime(2022,11,20, 17, 00);
  DateTime deadlineProgression = DateTime(2022,11,20, 17, 00);

  List<bool> matchGroupCollapsed = [];
  Map<String,List<TextEditingController>> textControllers = {};
  List<TextEditingController> textControllersRandom = [];
  PageController progressionController = PageController(viewportFraction: min(500/Get.width, 1.0), initialPage: 1);
  int progressionPageIdx = 1;
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
    MatchGroup groupMatches = MatchGroup("Group Phase", DateTime(2022,11,20, 17, 00));
    // ignore: non_constant_identifier_names
    MatchGroup R16Matches = MatchGroup("Round of 16", DateTime(2022,12, 3, 16, 00));
    // ignore: non_constant_identifier_names
    MatchGroup QFMatches = MatchGroup("Quarter Finals", DateTime(2022,12, 9, 16, 00));
    // ignore: non_constant_identifier_names
    MatchGroup SFMatches = MatchGroup("Semi Finals", DateTime(2022,12,13, 20, 00));
    // ignore: non_constant_identifier_names
    MatchGroup FMatches = MatchGroup("Finals", DateTime(2022,12,17, 20, 00));
    matchIds.addAll(groupMatchesIds);
    for (String id in groupMatchesIds) {dealines[id] = groupMatches;}
    groups.add(groupMatches);

    matchIds.addAll(R16MatchesIds);
    for (String id in R16MatchesIds) {dealines[id] = R16Matches;}
    groups.add(R16Matches);

    matchIds.addAll(QFMatchesIds);
    for (String id in QFMatchesIds) {dealines[id] = QFMatches;}
    groups.add(QFMatches);

    matchIds.addAll(SFMatchesIds);
    for (String id in SFMatchesIds) {dealines[id] = SFMatches;}
    groups.add(SFMatches);

    matchIds.addAll(FMatchesIds);
    for (String id in FMatchesIds) {dealines[id] = FMatches;}
    groups.add(FMatches);

    for (MatchGroup _ in groups) {matchGroupCollapsed.add(true);}
  }


  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  void initPronostiek() {
    repo.getPronostiek().then((pronostiek) {
      this.pronostiek = pronostiek;
      for (var element in matchIds) {textControllers[element] = [TextEditingController(text: pronostiek!.matches[element]?.goalsHomeFT?.toString() ?? ""),TextEditingController(text: pronostiek.matches[element]!.goalsAwayFT?.toString() ?? "")];}
      for (RandomPronostiek element in pronostiek!.random) {textControllersRandom.add(TextEditingController(text: element.answer ?? ""));}
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
    await repo.savePronostiek(pronostiek!);
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

}
