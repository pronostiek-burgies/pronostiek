import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/match.dart';

Map<String,Match> getMatches(Map<String,Team> teams, MatchController controller) {
  Team? getWinnerOfGroup(String groupId) {
    if (!controller.groups[groupId]!.finished()) {
      return null;
    }
    return controller.groups[groupId]!.ranked[0];
  }
  Team? getRunnerUpOfGroup(String groupId) {
    if (!controller.groups[groupId]!.finished()) {
      return null;
    }
    return controller.groups[groupId]!.ranked[1];
  }
  Team? getWinnerOfMatch(String matchId) {
    return controller.matches[matchId]!.getWinner();
  }
  Team? getLoserOfMatch(String matchId) {
    return controller.matches[matchId]!.getLoser();
  }
  
  return {
    "A1": Match("A1", DateTime(2022, 11, 20, 17, 00), teams["A1"]!, teams["A2"]!),
    "A2": Match("A2", DateTime(2022, 11, 21, 17, 00), teams["A3"]!, teams["A4"]!),
    "A3": Match("A3", DateTime(2022, 11, 25, 14, 00), teams["A1"]!, teams["A3"]!),
    "A4": Match("A4", DateTime(2022, 11, 25, 17, 00), teams["A4"]!, teams["A2"]!),
    "A5": Match("A5", DateTime(2022, 11, 29, 16, 00), teams["A4"]!, teams["A1"]!),
    "A6": Match("A5", DateTime(2022, 11, 29, 16, 00), teams["A2"]!, teams["A3"]!),

    "B1": Match("B1", DateTime(2022, 11, 21, 14, 00), teams["B1"]!, teams["B2"]!),
    "B2": Match("B2", DateTime(2022, 11, 21, 20, 00), teams["B3"]!, teams["B4"]!),
    "B3": Match("B3", DateTime(2022, 11, 25, 20, 00), teams["B1"]!, teams["B3"]!),
    "B4": Match("B4", DateTime(2022, 11, 25, 11, 00), teams["B4"]!, teams["B2"]!),
    "B5": Match("B5", DateTime(2022, 11, 29, 20, 00), teams["B4"]!, teams["B1"]!),
    "B6": Match("B5", DateTime(2022, 11, 29, 20, 00), teams["B2"]!, teams["B3"]!),

    "C1": Match("C1", DateTime(2022, 11, 22, 11, 00), teams["C1"]!, teams["C2"]!),
    "C2": Match("C2", DateTime(2022, 11, 22, 17, 00), teams["C3"]!, teams["C4"]!),
    "C3": Match("C3", DateTime(2022, 11, 26, 20, 00), teams["C1"]!, teams["C3"]!),
    "C4": Match("C4", DateTime(2022, 11, 26, 14, 00), teams["C4"]!, teams["C2"]!),
    "C5": Match("C5", DateTime(2022, 11, 30, 20, 00), teams["C4"]!, teams["C1"]!),
    "C6": Match("C5", DateTime(2022, 11, 30, 20, 00), teams["C2"]!, teams["C3"]!),

    "D1": Match("D1", DateTime(2022, 11, 22, 20, 00), teams["D1"]!, teams["D2"]!),
    "D2": Match("D2", DateTime(2022, 11, 22, 14, 00), teams["D3"]!, teams["D4"]!),
    "D3": Match("D3", DateTime(2022, 11, 26, 17, 00), teams["D1"]!, teams["D3"]!),
    "D4": Match("D4", DateTime(2022, 11, 26, 11, 00), teams["D4"]!, teams["D2"]!),
    "D5": Match("D5", DateTime(2022, 11, 30, 16, 00), teams["D4"]!, teams["D1"]!),
    "D6": Match("D5", DateTime(2022, 11, 30, 16, 00), teams["D2"]!, teams["D3"]!),

    "E1": Match("E1", DateTime(2022, 11, 23, 17, 00), teams["E1"]!, teams["E2"]!),
    "E2": Match("E2", DateTime(2022, 11, 23, 14, 00), teams["E3"]!, teams["E4"]!),
    "E3": Match("E3", DateTime(2022, 11, 27, 20, 00), teams["E1"]!, teams["E3"]!),
    "E4": Match("E4", DateTime(2022, 11, 27, 11, 00), teams["E4"]!, teams["E2"]!),
    "E5": Match("E5", DateTime(2022, 12,  1, 20, 00), teams["E4"]!, teams["E1"]!),
    "E6": Match("E5", DateTime(2022, 12,  1, 20, 00), teams["E2"]!, teams["E3"]!),

    "F1": Match("F1", DateTime(2022, 11, 23, 20, 00), teams["F1"]!, teams["F2"]!),
    "F2": Match("F2", DateTime(2022, 11, 23, 11, 00), teams["F3"]!, teams["F4"]!),
    "F3": Match("F3", DateTime(2022, 11, 27, 14, 00), teams["F1"]!, teams["F3"]!),
    "F4": Match("F4", DateTime(2022, 11, 27, 17, 00), teams["F4"]!, teams["F2"]!),
    "F5": Match("F5", DateTime(2022, 12,  1, 16, 00), teams["F4"]!, teams["F1"]!),
    "F6": Match("F5", DateTime(2022, 12,  1, 16, 00), teams["F2"]!, teams["F3"]!),

    "G1": Match("G1", DateTime(2022, 11, 24, 20, 00), teams["G1"]!, teams["G2"]!),
    "G2": Match("G2", DateTime(2022, 11, 24, 11, 00), teams["G3"]!, teams["G4"]!),
    "G3": Match("G3", DateTime(2022, 11, 28, 17, 00), teams["G1"]!, teams["G3"]!),
    "G4": Match("G4", DateTime(2022, 11, 28, 11, 00), teams["G4"]!, teams["G2"]!),
    "G5": Match("G5", DateTime(2022, 12,  2, 20, 00), teams["G4"]!, teams["G1"]!),
    "G6": Match("G5", DateTime(2022, 12,  2, 20, 00), teams["G2"]!, teams["G3"]!),

    "H1": Match("H1", DateTime(2022, 11, 24, 17, 00), teams["H1"]!, teams["H2"]!),
    "H2": Match("H2", DateTime(2022, 11, 24, 14, 00), teams["H3"]!, teams["H4"]!),
    "H3": Match("H3", DateTime(2022, 11, 28, 20, 00), teams["H1"]!, teams["H3"]!),
    "H4": Match("H4", DateTime(2022, 11, 28, 14, 00), teams["H4"]!, teams["H2"]!),
    "H5": Match("H5", DateTime(2022, 12,  2, 16, 00), teams["H4"]!, teams["H1"]!),
    "H6": Match("H5", DateTime(2022, 12,  2, 16, 00), teams["H2"]!, teams["H3"]!),

    "R16A": Match.knockout("R16A", DateTime(2022, 12, 3, 16, 00), "Winner A", "Runner-up B", () => getWinnerOfGroup("A"), () => getRunnerUpOfGroup("B")),
    "R16C": Match.knockout("R16C", DateTime(2022, 12, 3, 20, 00), "Winner C", "Runner-up D", () => getWinnerOfGroup("C"), () => getRunnerUpOfGroup("D")),
    "R16E": Match.knockout("R16E", DateTime(2022, 12, 5, 16, 00), "Winner E", "Runner-up F", () => getWinnerOfGroup("E"), () => getRunnerUpOfGroup("F")),
    "R16G": Match.knockout("R16G", DateTime(2022, 12, 5, 20, 00), "Winner G", "Runner-up H", () => getWinnerOfGroup("G"), () => getRunnerUpOfGroup("H")),
    "R16B": Match.knockout("R16B", DateTime(2022, 12, 4, 20, 00), "Winner B", "Runner-up A", () => getWinnerOfGroup("B"), () => getRunnerUpOfGroup("A")),
    "R16D": Match.knockout("R16D", DateTime(2022, 12, 4, 16, 00), "Winner D", "Runner-up C", () => getWinnerOfGroup("D"), () => getRunnerUpOfGroup("C")),
    "R16F": Match.knockout("R16F", DateTime(2022, 12, 6, 16, 00), "Winner F", "Runner-up E", () => getWinnerOfGroup("F"), () => getRunnerUpOfGroup("E")),
    "R16H": Match.knockout("R16H", DateTime(2022, 12, 6, 20, 00), "Winner H", "Runner-up G", () => getWinnerOfGroup("H"), () => getRunnerUpOfGroup("G")),

    "QF1": Match.knockout("QF1", DateTime(2022, 12,  9, 20, 00), "Winner R16A", "Winner R16C", () => getWinnerOfMatch("R16A"), () => getWinnerOfMatch("R16C")),
    "QF2": Match.knockout("QF2", DateTime(2022, 12,  9, 16, 00), "Winner R16E", "Winner R16G", () => getWinnerOfMatch("R16E"), () => getWinnerOfMatch("R16G")),
    "QF3": Match.knockout("QF3", DateTime(2022, 12, 10, 20, 00), "Winner R16B", "Winner R16D", () => getWinnerOfMatch("R16B"), () => getWinnerOfMatch("R16D")),
    "QF4": Match.knockout("QF4", DateTime(2022, 12, 10, 16, 00), "Winner R16F", "Winner R16G", () => getWinnerOfMatch("R16F"), () => getWinnerOfMatch("R16G")),
    
    "SF1": Match.knockout("SF1", DateTime(2022, 12, 13, 20, 00), "Winner QF1", "Winner QF2", () => getWinnerOfMatch("QF1"), () => getWinnerOfMatch("QF2")),
    "SF2": Match.knockout("SF2", DateTime(2022, 12, 14, 20, 00), "Winner QF3", "Winner QF4", () => getWinnerOfMatch("QF3"), () => getWinnerOfMatch("QF4")),
    
    "F": Match.knockout("F", DateTime(2022, 12, 18, 16, 00), "Winner SF1", "Winner SF2", () => getWinnerOfMatch("SF1"), () => getWinnerOfMatch("SF1")),
    "f": Match.knockout("f", DateTime(2022, 12, 17, 16, 00), "Runner-up SF1", "Runner-up SF2", () => getLoserOfMatch("SF1"), () => getLoserOfMatch("SF2")),
  };
}