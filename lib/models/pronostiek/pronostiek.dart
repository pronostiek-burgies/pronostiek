import 'dart:convert';

import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/progression_pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';


class MatchGroup {
  String name;
  DateTime deadline;

  MatchGroup(this.name, this.deadline);
}

// Map<String,MatchGroup> initMatchGroups() {
  
// }

class Pronostiek {
  static final List<String> matchIds = ["A1","A2","A3","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6",
                           "R16A","R16B","R16C","R16D","R16E","R16F","R16G","R16H",
                           "QF1","QF2","QF3","QF4",
                           "SF1","SF2",
                           "F","f"];
  
  static final List<String> teamIds = ["A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4"];

  List<String> groupMatchesIds = ["A1","A2","A3","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6"];
  
  // static Map<String, MatchGroup> matchGroupOfMatch = 
  //   // ignore: non_constant_identifier_names
  // List<String> R16MatchesIds = ["R16A","R16B","R16C","R16D","R16E","R16F","R16G","R16H"];
  // // ignore: non_constant_identifier_names
  // List<String> QFMatchesIds = ["QF1","QF2","QF3","QF4"];
  // // ignore: non_constant_identifier_names
  // List<String> SFMatchesIds = ["SF1", "SF2"];
  // // ignore: non_constant_identifier_names
  // List<String> FMatchesIds = ["F", "f"];
  // MatchGroup groupMatches = MatchGroup("Group Phase", DateTime.utc(2022,11,20, 16, 00));
  // // MatchGroup groupMatches = MatchGroup("Group Phase", DateTime.utc(2022,10,20, 8, 52));
  // // ignore: non_constant_identifier_names
  // MatchGroup R16Matches = MatchGroup("Round of 16", DateTime.utc(2022,12, 3, 15, 00));
  // // ignore: non_constant_identifier_names
  // MatchGroup QFMatches = MatchGroup("Quarter Finals", DateTime.utc(2022,12, 9, 15, 00));
  // // ignore: non_constant_identifier_names
  // MatchGroup SFMatches = MatchGroup("Semi Finals", DateTime.utc(2022,12,13, 19, 00));
  // // ignore: non_constant_identifier_names
  // MatchGroup FMatches = MatchGroup("Finals", DateTime.utc(2022,12,17, 19, 00));

  late String username;

  /// Matches present in the pronostiek with key matchId.
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
    random = List<RandomPronostiek>.from(RandomPronostiek.questions.keys.map<RandomPronostiek>((String id) => RandomPronostiek.fromJson(jsonDecode(jsonEncode(json["random"].firstWhere((e) => e["id"] == id, orElse: () => null) ?? {'id': id})))));
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