import 'dart:convert';

import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';


class MatchGroup {
  String name;
  DateTime deadline;

  MatchGroup(this.name, this.deadline);
}


class Pronostiek {
  static final List<String> matchIds = ["A1","A2","A3","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6",
                           "R16A","R16B","R16C","R16D","R16E","R16F","R16G","R16H",
                           "QF1","QF2","QF3","QF4",
                           "SF1","SF2",
                           "F","f"];
  
  static final List<String> teamIds = ["A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4"];

  late String username;
  late Map<String, MatchPronostiek> matches;
  ProgressionPronostiek progression = ProgressionPronostiek();
  List<RandomPronostiek> random = RandomPronostiek.getQuestions();

  Pronostiek(this.username) {
    matches = {};
    for (String id in matchIds) {
      matches[id] = MatchPronostiek(id, null, null, null);
    }
  }

  Pronostiek.fromJson(Map<String,dynamic> json) {
    username = json["username"];
    matches = {};
    json["matches"].forEach((id, match) {
      matches[id] = MatchPronostiek.fromJson(jsonDecode(jsonEncode(match)));
    });
    progression = ProgressionPronostiek.fromJson(jsonDecode(jsonEncode(json["progression"])));
    random = List<RandomPronostiek>.from(json["random"].map<RandomPronostiek>((question) => RandomPronostiek.fromJson(jsonDecode(jsonEncode(question)))));
  }

  Map<String,dynamic> toJson() {
    return {
      "username": username,
      "matches": matches.map((id, match) => MapEntry<String, dynamic>(id, match.toJson())),
      "progression": progression.toJson(),
      "random": random.map((question) => question.toJson()).toList(),
    };
  }

}