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
    "A1": Match("A1", DateTime.utc(2022, 11, 20, 17-1, 00), teams["A1"]!, teams["A2"]!,  MatchType.group, sporzaApi: 3311844),
    "A2": Match("A2", DateTime.utc(2022, 11, 21, 17-1, 00), teams["A3"]!, teams["A4"]!,  MatchType.group, sporzaApi: 3311843),
    "A3": Match("A3", DateTime.utc(2022, 11, 25, 14-1, 00), teams["A1"]!, teams["A3"]!,  MatchType.group, sporzaApi: 3311842),
    "A4": Match("A4", DateTime.utc(2022, 11, 25, 17-1, 00), teams["A4"]!, teams["A2"]!,  MatchType.group, sporzaApi: 3311841),
    "A5": Match("A5", DateTime.utc(2022, 11, 29, 16-1, 00), teams["A4"]!, teams["A1"]!,  MatchType.group, sporzaApi: 3311840),
    "A6": Match("A6", DateTime.utc(2022, 11, 29, 16-1, 00), teams["A2"]!, teams["A3"]!,  MatchType.group, sporzaApi: 3311839),

    "B1": Match("B1", DateTime.utc(2022, 11, 21, 14-1, 00), teams["B1"]!, teams["B2"]!,  MatchType.group, sporzaApi: 3311850),
    "B2": Match("B2", DateTime.utc(2022, 11, 21, 20-1, 00), teams["B3"]!, teams["B4"]!,  MatchType.group, sporzaApi: 3311849),
    "B3": Match("B3", DateTime.utc(2022, 11, 25, 20-1, 00), teams["B1"]!, teams["B3"]!,  MatchType.group, sporzaApi: 3311848),
    "B4": Match("B4", DateTime.utc(2022, 11, 25, 11-1, 00), teams["B4"]!, teams["B2"]!,  MatchType.group, sporzaApi: 3311847),
    "B5": Match("B5", DateTime.utc(2022, 11, 29, 20-1, 00), teams["B4"]!, teams["B1"]!,  MatchType.group, sporzaApi: 3311846),
    "B6": Match("B6", DateTime.utc(2022, 11, 29, 20-1, 00), teams["B2"]!, teams["B3"]!,  MatchType.group, sporzaApi: 3311845),

    "C1": Match("C1", DateTime.utc(2022, 11, 22, 11-1, 00), teams["C1"]!, teams["C2"]!,  MatchType.group, sporzaApi: 3311856),
    "C2": Match("C2", DateTime.utc(2022, 11, 22, 17-1, 00), teams["C3"]!, teams["C4"]!,  MatchType.group, sporzaApi: 3311855),
    "C3": Match("C3", DateTime.utc(2022, 11, 26, 20-1, 00), teams["C1"]!, teams["C3"]!,  MatchType.group, sporzaApi: 3311854),
    "C4": Match("C4", DateTime.utc(2022, 11, 26, 14-1, 00), teams["C4"]!, teams["C2"]!,  MatchType.group, sporzaApi: 3311853),
    "C5": Match("C5", DateTime.utc(2022, 11, 30, 20-1, 00), teams["C4"]!, teams["C1"]!,  MatchType.group, sporzaApi: 3311852),
    "C6": Match("C6", DateTime.utc(2022, 11, 30, 20-1, 00), teams["C2"]!, teams["C3"]!,  MatchType.group, sporzaApi: 3311851),

    "D1": Match("D1", DateTime.utc(2022, 11, 22, 20-1, 00), teams["D1"]!, teams["D2"]!,  MatchType.group, sporzaApi: 3311862),
    "D2": Match("D2", DateTime.utc(2022, 11, 22, 14-1, 00), teams["D3"]!, teams["D4"]!,  MatchType.group, sporzaApi: 3311861),
    "D3": Match("D3", DateTime.utc(2022, 11, 26, 17-1, 00), teams["D1"]!, teams["D3"]!,  MatchType.group, sporzaApi: 3311860),
    "D4": Match("D4", DateTime.utc(2022, 11, 26, 11-1, 00), teams["D4"]!, teams["D2"]!,  MatchType.group, sporzaApi: 3311859),
    "D5": Match("D5", DateTime.utc(2022, 11, 30, 16-1, 00), teams["D4"]!, teams["D1"]!,  MatchType.group, sporzaApi: 3311858),
    "D6": Match("D6", DateTime.utc(2022, 11, 30, 16-1, 00), teams["D2"]!, teams["D3"]!,  MatchType.group, sporzaApi: 3311857),

    "E1": Match("E1", DateTime.utc(2022, 11, 23, 17-1, 00), teams["E1"]!, teams["E2"]!,  MatchType.group, sporzaApi: 3311868),
    "E2": Match("E2", DateTime.utc(2022, 11, 23, 14-1, 00), teams["E3"]!, teams["E4"]!,  MatchType.group, sporzaApi: 3311867),
    "E3": Match("E3", DateTime.utc(2022, 11, 27, 20-1, 00), teams["E1"]!, teams["E3"]!,  MatchType.group, sporzaApi: 3311866),
    "E4": Match("E4", DateTime.utc(2022, 11, 27, 11-1, 00), teams["E4"]!, teams["E2"]!,  MatchType.group, sporzaApi: 3311865),
    "E5": Match("E5", DateTime.utc(2022, 12,  1, 20-1, 00), teams["E4"]!, teams["E1"]!,  MatchType.group, sporzaApi: 3311864),
    "E6": Match("E6", DateTime.utc(2022, 12,  1, 20-1, 00), teams["E2"]!, teams["E3"]!,  MatchType.group, sporzaApi: 3311863),

    "F1": Match("F1", DateTime.utc(2022, 11, 23, 20-1, 00), teams["F1"]!, teams["F2"]!,  MatchType.group, sporzaApi: 3311874),
    "F2": Match("F2", DateTime.utc(2022, 11, 23, 11-1, 00), teams["F3"]!, teams["F4"]!,  MatchType.group, sporzaApi: 3311873),
    "F3": Match("F3", DateTime.utc(2022, 11, 27, 14-1, 00), teams["F1"]!, teams["F3"]!,  MatchType.group, sporzaApi: 3311872),
    "F4": Match("F4", DateTime.utc(2022, 11, 27, 17-1, 00), teams["F4"]!, teams["F2"]!,  MatchType.group, sporzaApi: 3311871),
    "F5": Match("F5", DateTime.utc(2022, 12,  1, 16-1, 00), teams["F4"]!, teams["F1"]!,  MatchType.group, sporzaApi: 3311870),
    "F6": Match("F6", DateTime.utc(2022, 12,  1, 16-1, 00), teams["F2"]!, teams["F3"]!,  MatchType.group, sporzaApi: 3311869),

    "G1": Match("G1", DateTime.utc(2022, 11, 24, 20-1, 00), teams["G1"]!, teams["G2"]!,  MatchType.group, sporzaApi: 3311880),
    "G2": Match("G2", DateTime.utc(2022, 11, 24, 11-1, 00), teams["G3"]!, teams["G4"]!,  MatchType.group, sporzaApi: 3311879),
    "G3": Match("G3", DateTime.utc(2022, 11, 28, 17-1, 00), teams["G1"]!, teams["G3"]!,  MatchType.group, sporzaApi: 3311878),
    "G4": Match("G4", DateTime.utc(2022, 11, 28, 11-1, 00), teams["G4"]!, teams["G2"]!,  MatchType.group, sporzaApi: 3311877),
    "G5": Match("G5", DateTime.utc(2022, 12,  2, 20-1, 00), teams["G4"]!, teams["G1"]!,  MatchType.group, sporzaApi: 3311876),
    "G6": Match("G6", DateTime.utc(2022, 12,  2, 20-1, 00), teams["G2"]!, teams["G3"]!,  MatchType.group, sporzaApi: 3311875),

    "H1": Match("H1", DateTime.utc(2022, 11, 24, 17-1, 00), teams["H1"]!, teams["H2"]!,  MatchType.group, sporzaApi: 3311886),
    "H2": Match("H2", DateTime.utc(2022, 11, 24, 14-1, 00), teams["H3"]!, teams["H4"]!,  MatchType.group, sporzaApi: 3311885),
    "H3": Match("H3", DateTime.utc(2022, 11, 28, 20-1, 00), teams["H1"]!, teams["H3"]!,  MatchType.group, sporzaApi: 3311884),
    "H4": Match("H4", DateTime.utc(2022, 11, 28, 14-1, 00), teams["H4"]!, teams["H2"]!,  MatchType.group, sporzaApi: 3311883),
    "H5": Match("H5", DateTime.utc(2022, 12,  2, 16-1, 00), teams["H4"]!, teams["H1"]!,  MatchType.group, sporzaApi: 3311882),
    "H6": Match("H6", DateTime.utc(2022, 12,  2, 16-1, 00), teams["H2"]!, teams["H3"]!,  MatchType.group, sporzaApi: 3311881),

    "R16A": Match.knockout("R16A", DateTime.utc(2022, 12, 3, 16-1, 00), "Winner A", "Runner-up B", () => getWinnerOfGroup("A"), () => getRunnerUpOfGroup("B"), MatchType.roundOf16, sporzaApi: 3311895, apiSports: 976533),
    "R16C": Match.knockout("R16C", DateTime.utc(2022, 12, 3, 20-1, 00), "Winner C", "Runner-up D", () => getWinnerOfGroup("C"), () => getRunnerUpOfGroup("D"), MatchType.roundOf16, sporzaApi: 3311897, apiSports: 976642),
    "R16E": Match.knockout("R16E", DateTime.utc(2022, 12, 5, 16-1, 00), "Winner E", "Runner-up F", () => getWinnerOfGroup("E"), () => getRunnerUpOfGroup("F"), MatchType.roundOf16, sporzaApi: 3311899, apiSports: 977344),
    "R16G": Match.knockout("R16G", DateTime.utc(2022, 12, 5, 20-1, 00), "Winner G", "Runner-up H", () => getWinnerOfGroup("G"), () => getRunnerUpOfGroup("H"), MatchType.roundOf16, sporzaApi: 3311901, apiSports: 977705),
    "R16B": Match.knockout("R16B", DateTime.utc(2022, 12, 4, 20-1, 00), "Winner B", "Runner-up A", () => getWinnerOfGroup("B"), () => getRunnerUpOfGroup("A"), MatchType.roundOf16, sporzaApi: 3311896, apiSports: 976534),
    "R16D": Match.knockout("R16D", DateTime.utc(2022, 12, 4, 16-1, 00), "Winner D", "Runner-up C", () => getWinnerOfGroup("D"), () => getRunnerUpOfGroup("C"), MatchType.roundOf16, sporzaApi: 3311898, apiSports: 976643),
    "R16F": Match.knockout("R16F", DateTime.utc(2022, 12, 6, 16-1, 00), "Winner F", "Runner-up E", () => getWinnerOfGroup("F"), () => getRunnerUpOfGroup("E"), MatchType.roundOf16, sporzaApi: 3311900, apiSports: 977345),
    "R16H": Match.knockout("R16H", DateTime.utc(2022, 12, 6, 20-1, 00), "Winner H", "Runner-up G", () => getWinnerOfGroup("H"), () => getRunnerUpOfGroup("G"), MatchType.roundOf16, sporzaApi: 3311902, apiSports: 977706),

    "QF1": Match.knockout("QF1", DateTime.utc(2022, 12,  9, 20-1, 00), "Winner R16A", "Winner R16C", () => getWinnerOfMatch("R16A"), () => getWinnerOfMatch("R16C"), MatchType.quarterFinals, sporzaApi: 3311887, apiSports: 977794),
    "QF2": Match.knockout("QF2", DateTime.utc(2022, 12,  9, 16-1, 00), "Winner R16E", "Winner R16G", () => getWinnerOfMatch("R16E"), () => getWinnerOfMatch("R16G"), MatchType.quarterFinals, sporzaApi: 3311889, apiSports: 978072),
    "QF3": Match.knockout("QF3", DateTime.utc(2022, 12, 10, 20-1, 00), "Winner R16B", "Winner R16D", () => getWinnerOfMatch("R16B"), () => getWinnerOfMatch("R16D"), MatchType.quarterFinals, sporzaApi: 3311888, apiSports: 978036),
    "QF4": Match.knockout("QF4", DateTime.utc(2022, 12, 10, 16-1, 00), "Winner R16F", "Winner R16H", () => getWinnerOfMatch("R16F"), () => getWinnerOfMatch("R16H"), MatchType.quarterFinals, sporzaApi: 3311890, apiSports: 978088),
    
    "SF1": Match.knockout("SF1", DateTime.utc(2022, 12, 13, 20-1, 00), "Winner QF1", "Winner QF2", () => getWinnerOfMatch("QF1"), () => getWinnerOfMatch("QF2"), MatchType.semiFinals, sporzaApi: 3311891),
    "SF2": Match.knockout("SF2", DateTime.utc(2022, 12, 14, 20-1, 00), "Winner QF3", "Winner QF4", () => getWinnerOfMatch("QF3"), () => getWinnerOfMatch("QF4"), MatchType.semiFinals, sporzaApi: 3311892),
    
    "F": Match.knockout("F", DateTime.utc(2022, 12, 18, 16-1, 00), "Winner SF1", "Winner SF2", () => getWinnerOfMatch("SF1"), () => getWinnerOfMatch("SF2"), MatchType.wcFinal, sporzaApi: 3311894),
    "f": Match.knockout("f", DateTime.utc(2022, 12, 17, 16-1, 00), "Runner-up SF1", "Runner-up SF2", () => getLoserOfMatch("SF1"), () => getLoserOfMatch("SF2"), MatchType.bronzeFinal, sporzaApi: 3311893),
  };
}