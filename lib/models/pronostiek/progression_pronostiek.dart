

import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';

class ProgressionPronostiek {
  /// list with team ID's
  List<String?> round16 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
  List<String?> quarterFinals = [null,null,null,null,null,null,null,null];
  List<String?> semiFinals = [null,null,null,null];
  List<String?> wcFinal = [null, null];
  String? winner;

  ProgressionPronostiek();

  ProgressionPronostiek.fromJson(Map<String,dynamic> json) {
    round16 = List<String?>.from(json["round16"]);    
    quarterFinals = List<String?>.from(json["quarter_finals"]);    
    semiFinals = List<String?>.from(json["semi_finals"]);    
    wcFinal = List<String?>.from(json["final"]);
    winner = json["winner"] as String?;  
  }

  Map<String,dynamic> toJson() {
    return {
      "round16": round16,
      "quarter_finals": quarterFinals,
      "semi_finals": semiFinals,
      "final": wcFinal,
      "winner": winner,
    };
  }
}