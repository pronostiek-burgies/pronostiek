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
    "SER-CHA": Match("SER-CHA", DateTime.utc(2022, 11, 8, 18, 30), Team("RFC Seraing", "SER", "eu", "RFC Seraing"), Team("Charleroi", "CHA", "eu", "Charleroi"), MatchType.group, sporzaApi: 3324002, apiSports: 963361, knockout: true),
    "DEI-KAS": Match("DEI-KAS", DateTime.utc(2022, 11, 8, 19, 0), Team("Deinze", "DEI", "eu", "Deinze"), Team("KAS Eupen", "KAS", "eu", "KAS"), MatchType.group, sporzaApi: 3323993, apiSports: 963350, knockout: true),
    "DEN-STA": Match("DEN-STA", DateTime.utc(2022, 11, 8, 19, 30), Team("Dender", "DEN", "eu", "Dender"), Team("Standard", "STA", "eu", "Standard"), MatchType.group, sporzaApi: 3323983, apiSports: 963348, knockout: true),
    "FBO-OHL": Match("FBO-OHL", DateTime.utc(2022, 11, 8, 19, 30), Team("Francs Borains", "FBO", "eu", "Francs Borains"), Team("OH Leuven", "OHL", "eu", "OH Leuven"), MatchType.group, sporzaApi: 3323996, apiSports: 963358, knockout: true),
    
    "CER-BEE": Match("CER-BEE", DateTime.utc(2022, 11, 9, 19, 0), Team("Cercle Brugge", "CER", "eu", "Cercle Brugge"), Team("Beerschot", "BEE", "eu", "Beerschot"), MatchType.group, sporzaApi: 3323982, apiSports: 963354, knockout: true),
    "LOM-ZWA": Match("LOM-ZWA", DateTime.utc(2022, 11, 9, 19, 0), Team("Lommel SK", "LOM", "eu", "Lommel SK"), Team("Zulte Waregem", "ZWA", "eu", "Zulte Waregem"), MatchType.group, sporzaApi: 3323985, apiSports: 963352, knockout: true),
    "CAP-USG": Match("CAP-USG", DateTime.utc(2022, 11, 9, 19, 0), Team("Cappellen", "CAP", "eu", "Cappellen"), Team("Union", "USG", "eu", "Union"), MatchType.group, sporzaApi: 3323988, apiSports: 963362, knockout: true),
    "LOK-KVM": Match("LOK-KVM", DateTime.utc(2022, 11, 9, 19, 0), Team("KSC Lokeren-Temse", "LOK", "eu", "KSC Lokeren-Temse"), Team("KV Mechelen", "KVM", "eu", "KV Mechelen"), MatchType.group, sporzaApi: 3323989, apiSports: 963363, knockout: true),
    "THE-KVO": Match("THE-KVO", DateTime.utc(2022, 11, 9, 19, 0), Team("Thes Sport", "THE", "eu", "Thes Sport"), Team("KV Oostende", "KVO", "eu", "KV Oostende"), MatchType.group, sporzaApi: 3323995, apiSports: 963359, knockout: true),
    "WES-GNK": Match("WES-GNK", DateTime.utc(2022, 11, 9, 19, 30), Team("Westerlo", "WES", "eu", "Westerlo"), Team("KRC Genk", "GNK", "eu", "KRC Genk"), MatchType.group, sporzaApi: 3323986, apiSports: 963351, knockout: true),
    "STV-MEU": Match("STV-MEU", DateTime.utc(2022, 11, 9, 19, 30), Team("STVV", "STV", "eu", "STVV"), Team("Meux", "MEU", "eu", "Meux"), MatchType.group, sporzaApi: 3323987, apiSports: 963356, knockout: true),
    "DES-GNT": Match("DES-GNT", DateTime.utc(2022, 11, 9, 19, 30), Team("Dessel Sport", "DES", "eu", "Dessel Sport"), Team("KAA Gent", "GNT", "eu", "KAA Gent"), MatchType.group, sporzaApi: 3324006, apiSports: 963357, knockout: true),
    "MAA-CLU": Match("MAA-CLU", DateTime.utc(2022, 11, 9, 19, 45), Team("Patro Eisden Maasmechelen", "MAA", "eu", "Patro Eisden Maasmechelen"), Team("Club Brugge", "CLU", "eu", "Club Brugge"), MatchType.group, sporzaApi: 3323994, apiSports: 963355, knockout: true),
    
    // "RAY-RMA": Match("RAY-RMA", DateTime.utc(2022, 11, 7, 20, 0), Team("Rayo Vallecano", "RAY", "eu", "test"), Team("Real Madrid", "RMA", "eu", "test"), MatchType.group, sporzaApi: 3317566),
    // "WOL-BVB": Match("WOL-BVB", DateTime.utc(2022, 11, 8, 17, 30), Team("VfL Wolfsburg", "WOL", "eu", "VfL Wolfsburg"), Team("Borussia Dortmund", "BVB", "eu", "Borussia Dortmund"), MatchType.group, sporzaApi: 3316021),
    // "VFB-HER": Match("VFB-HER", DateTime.utc(2022, 11, 8, 19, 30), Team("VfB Stuttgart", "VFB", "eu", "VfB Stuttgart"), Team("Hertha BSC", "HER", "eu", "Hertha BSC"), MatchType.group, sporzaApi: 3316008),
    // "BOC-BMG": Match("BOC-BMG", DateTime.utc(2022, 11, 8, 19, 30), Team("VfL Bochum", "BOC", "eu", "VfL Bochum"), Team("Borussia Mönchengladbach", "BMG", "eu", "Borussia Mönchengladbach"), MatchType.group, sporzaApi: 3316013),
    // "FCB-WER": Match("FCB-WER", DateTime.utc(2022, 11, 8, 19, 30), Team("FC Bayern München", "FCB", "eu", "FC Bayern München"), Team("Werder Bremen", "WER", "eu", "Werder Bremen"), MatchType.group, sporzaApi: 3316014),
    // "LEI-NEW": Match("LEI-NEW", DateTime.utc(2022, 11, 8, 19, 45), Team("Leicester City", "LEI", "eu", "Leicester City"), Team("Newport County", "NEW", "eu", "Newport County"), MatchType.group, sporzaApi: 3317496),
    // "BOU-EVE": Match("BOU-EVE", DateTime.utc(2022, 11, 8, 19, 45), Team("Bournemouth", "BOU", "eu", "Bournemouth"), Team("Everton", "EVE", "eu", "Everton"), MatchType.group, sporzaApi: 3317501),
    // "BUR-CRA": Match("BUR-CRA", DateTime.utc(2022, 11, 8, 19, 45), Team("Burnley", "BUR", "eu", "Burnley"), Team("Crawley Town", "CRA", "eu", "Crawley Town"), MatchType.group, sporzaApi: 3317503),
    // "BRI-LIN": Match("BRI-LIN", DateTime.utc(2022, 11, 8, 19, 45), Team("Bristol City", "BRI", "eu", "Bristol City"), Team("Lincoln City", "LIN", "eu", "Lincoln City"), MatchType.group, sporzaApi: 3317504),
    // "STE-CHA": Match("STE-CHA", DateTime.utc(2022, 11, 8, 19, 45), Team("Stevenage", "STE", "eu", "Stevenage"), Team("Charlton Athletic", "CHA", "eu", "Charlton Athletic"), MatchType.group, sporzaApi: 3317506),
    // "MK Dons-MOR": Match("MK Dons-MOR", DateTime.utc(2022, 11, 8, 19, 45), Team("Milton Keynes Dons", "MK Dons", "eu", "Milton Keynes Dons"), Team("Morecambe", "MOR", "eu", "Morecambe"), MatchType.group, sporzaApi: 3317507),
    // "BRE-GIL": Match("BRE-GIL", DateTime.utc(2022, 11, 8, 19, 45), Team("Brentford", "BRE", "eu", "Brentford"), Team("Gillingham", "GIL", "eu", "Gillingham"), MatchType.group, sporzaApi: 3317511),
    // "ECF-GIR": Match("ECF-GIR", DateTime.utc(2022, 11, 8, 18, 0), Team("Elche CF", "ECF", "eu", "Elche CF"), Team("Girona FC", "GIR", "eu", "Girona FC"), MatchType.group, sporzaApi: 3317533),
    // "ATH-VLD": Match("ATH-VLD", DateTime.utc(2022, 11, 8, 19, 0), Team("Athletic Club", "ATH", "eu", "Athletic Club"), Team("Real Valladolid", "VLD", "eu", "Real Valladolid"), MatchType.group, sporzaApi: 3317536),
    // "OSA-BAR": Match("OSA-BAR", DateTime.utc(2022, 11, 8, 20, 30), Team("CA Osasuna", "OSA", "eu", "CA Osasuna"), Team("FC Barcelona", "BAR", "eu", "FC Barcelona"), MatchType.group, sporzaApi: 3317578),
    // "NAP-EMP": Match("NAP-EMP", DateTime.utc(2022, 11, 8, 17, 30), Team("Napoli", "NAP", "eu", "Napoli"), Team("Empoli", "EMP", "eu", "Empoli"), MatchType.group, sporzaApi: 3317984),
    // "SPE-UDI": Match("SPE-UDI", DateTime.utc(2022, 11, 8, 17, 30), Team("Spezia", "SPE", "eu", "Spezia"), Team("Udinese", "UDI", "eu", "Udinese"), MatchType.group, sporzaApi: 3318004),
    // "CRE-MIL": Match("CRE-MIL", DateTime.utc(2022, 11, 8, 19, 45), Team("Cremonese", "CRE", "eu", "Cremonese"), Team("AC Milan", "MIL", "eu", "AC Milan"), MatchType.group, sporzaApi: 3317978),

    "A1": Match("A1", DateTime.utc(2022, 11, 20, 17-1, 00), teams["A1"]!, teams["A2"]!,  MatchType.group),
    "A2": Match("A2", DateTime.utc(2022, 11, 21, 17-1, 00), teams["A3"]!, teams["A4"]!,  MatchType.group),
    "A3": Match("A3", DateTime.utc(2022, 11, 25, 14-1, 00), teams["A1"]!, teams["A3"]!,  MatchType.group),
    "A4": Match("A4", DateTime.utc(2022, 11, 25, 17-1, 00), teams["A4"]!, teams["A2"]!,  MatchType.group),
    "A5": Match("A5", DateTime.utc(2022, 11, 29, 16-1, 00), teams["A4"]!, teams["A1"]!,  MatchType.group),
    "A6": Match("A6", DateTime.utc(2022, 11, 29, 16-1, 00), teams["A2"]!, teams["A3"]!,  MatchType.group),

    "B1": Match("B1", DateTime.utc(2022, 11, 21, 14-1, 00), teams["B1"]!, teams["B2"]!,  MatchType.group),
    "B2": Match("B2", DateTime.utc(2022, 11, 21, 20-1, 00), teams["B3"]!, teams["B4"]!,  MatchType.group),
    "B3": Match("B3", DateTime.utc(2022, 11, 25, 20-1, 00), teams["B1"]!, teams["B3"]!,  MatchType.group),
    "B4": Match("B4", DateTime.utc(2022, 11, 25, 11-1, 00), teams["B4"]!, teams["B2"]!,  MatchType.group),
    "B5": Match("B5", DateTime.utc(2022, 11, 29, 20-1, 00), teams["B4"]!, teams["B1"]!,  MatchType.group),
    "B6": Match("B6", DateTime.utc(2022, 11, 29, 20-1, 00), teams["B2"]!, teams["B3"]!,  MatchType.group),

    "C1": Match("C1", DateTime.utc(2022, 11, 22, 11-1, 00), teams["C1"]!, teams["C2"]!,  MatchType.group),
    "C2": Match("C2", DateTime.utc(2022, 11, 22, 17-1, 00), teams["C3"]!, teams["C4"]!,  MatchType.group),
    "C3": Match("C3", DateTime.utc(2022, 11, 26, 20-1, 00), teams["C1"]!, teams["C3"]!,  MatchType.group),
    "C4": Match("C4", DateTime.utc(2022, 11, 26, 14-1, 00), teams["C4"]!, teams["C2"]!,  MatchType.group),
    "C5": Match("C5", DateTime.utc(2022, 11, 30, 20-1, 00), teams["C4"]!, teams["C1"]!,  MatchType.group),
    "C6": Match("C6", DateTime.utc(2022, 11, 30, 20-1, 00), teams["C2"]!, teams["C3"]!,  MatchType.group),

    "D1": Match("D1", DateTime.utc(2022, 11, 22, 20-1, 00), teams["D1"]!, teams["D2"]!,  MatchType.group),
    "D2": Match("D2", DateTime.utc(2022, 11, 22, 14-1, 00), teams["D3"]!, teams["D4"]!,  MatchType.group),
    "D3": Match("D3", DateTime.utc(2022, 11, 26, 17-1, 00), teams["D1"]!, teams["D3"]!,  MatchType.group),
    "D4": Match("D4", DateTime.utc(2022, 11, 26, 11-1, 00), teams["D4"]!, teams["D2"]!,  MatchType.group),
    "D5": Match("D5", DateTime.utc(2022, 11, 30, 16-1, 00), teams["D4"]!, teams["D1"]!,  MatchType.group),
    "D6": Match("D6", DateTime.utc(2022, 11, 30, 16-1, 00), teams["D2"]!, teams["D3"]!,  MatchType.group),

    "E1": Match("E1", DateTime.utc(2022, 11, 23, 17-1, 00), teams["E1"]!, teams["E2"]!,  MatchType.group),
    "E2": Match("E2", DateTime.utc(2022, 11, 23, 14-1, 00), teams["E3"]!, teams["E4"]!,  MatchType.group),
    "E3": Match("E3", DateTime.utc(2022, 11, 27, 20-1, 00), teams["E1"]!, teams["E3"]!,  MatchType.group),
    "E4": Match("E4", DateTime.utc(2022, 11, 27, 11-1, 00), teams["E4"]!, teams["E2"]!,  MatchType.group),
    "E5": Match("E5", DateTime.utc(2022, 12,  1, 20-1, 00), teams["E4"]!, teams["E1"]!,  MatchType.group),
    "E6": Match("E6", DateTime.utc(2022, 12,  1, 20-1, 00), teams["E2"]!, teams["E3"]!,  MatchType.group),

    "F1": Match("F1", DateTime.utc(2022, 11, 23, 20-1, 00), teams["F1"]!, teams["F2"]!,  MatchType.group),
    "F2": Match("F2", DateTime.utc(2022, 11, 23, 11-1, 00), teams["F3"]!, teams["F4"]!,  MatchType.group),
    "F3": Match("F3", DateTime.utc(2022, 11, 27, 14-1, 00), teams["F1"]!, teams["F3"]!,  MatchType.group),
    "F4": Match("F4", DateTime.utc(2022, 11, 27, 17-1, 00), teams["F4"]!, teams["F2"]!,  MatchType.group),
    "F5": Match("F5", DateTime.utc(2022, 12,  1, 16-1, 00), teams["F4"]!, teams["F1"]!,  MatchType.group),
    "F6": Match("F6", DateTime.utc(2022, 12,  1, 16-1, 00), teams["F2"]!, teams["F3"]!,  MatchType.group),

    "G1": Match("G1", DateTime.utc(2022, 11, 24, 20-1, 00), teams["G1"]!, teams["G2"]!,  MatchType.group),
    "G2": Match("G2", DateTime.utc(2022, 11, 24, 11-1, 00), teams["G3"]!, teams["G4"]!,  MatchType.group),
    "G3": Match("G3", DateTime.utc(2022, 11, 28, 17-1, 00), teams["G1"]!, teams["G3"]!,  MatchType.group),
    "G4": Match("G4", DateTime.utc(2022, 11, 28, 11-1, 00), teams["G4"]!, teams["G2"]!,  MatchType.group),
    "G5": Match("G5", DateTime.utc(2022, 12,  2, 20-1, 00), teams["G4"]!, teams["G1"]!,  MatchType.group),
    "G6": Match("G6", DateTime.utc(2022, 12,  2, 20-1, 00), teams["G2"]!, teams["G3"]!,  MatchType.group),

    "H1": Match("H1", DateTime.utc(2022, 11, 24, 17-1, 00), teams["H1"]!, teams["H2"]!,  MatchType.group),
    "H2": Match("H2", DateTime.utc(2022, 11, 24, 14-1, 00), teams["H3"]!, teams["H4"]!,  MatchType.group),
    "H3": Match("H3", DateTime.utc(2022, 11, 28, 20-1, 00), teams["H1"]!, teams["H3"]!,  MatchType.group),
    "H4": Match("H4", DateTime.utc(2022, 11, 28, 14-1, 00), teams["H4"]!, teams["H2"]!,  MatchType.group),
    "H5": Match("H5", DateTime.utc(2022, 12,  2, 16-1, 00), teams["H4"]!, teams["H1"]!,  MatchType.group),
    "H6": Match("H6", DateTime.utc(2022, 12,  2, 16-1, 00), teams["H2"]!, teams["H3"]!,  MatchType.group),

    "R16A": Match.knockout("R16A", DateTime.utc(2022, 12, 3, 16-1, 00), "Winner A", "Runner-up B", () => getWinnerOfGroup("A"), () => getRunnerUpOfGroup("B"), MatchType.roundOf16),
    "R16C": Match.knockout("R16C", DateTime.utc(2022, 12, 3, 20-1, 00), "Winner C", "Runner-up D", () => getWinnerOfGroup("C"), () => getRunnerUpOfGroup("D"), MatchType.roundOf16),
    "R16E": Match.knockout("R16E", DateTime.utc(2022, 12, 5, 16-1, 00), "Winner E", "Runner-up F", () => getWinnerOfGroup("E"), () => getRunnerUpOfGroup("F"), MatchType.roundOf16),
    "R16G": Match.knockout("R16G", DateTime.utc(2022, 12, 5, 20-1, 00), "Winner G", "Runner-up H", () => getWinnerOfGroup("G"), () => getRunnerUpOfGroup("H"), MatchType.roundOf16),
    "R16B": Match.knockout("R16B", DateTime.utc(2022, 12, 4, 20-1, 00), "Winner B", "Runner-up A", () => getWinnerOfGroup("B"), () => getRunnerUpOfGroup("A"), MatchType.roundOf16),
    "R16D": Match.knockout("R16D", DateTime.utc(2022, 12, 4, 16-1, 00), "Winner D", "Runner-up C", () => getWinnerOfGroup("D"), () => getRunnerUpOfGroup("C"), MatchType.roundOf16),
    "R16F": Match.knockout("R16F", DateTime.utc(2022, 12, 6, 16-1, 00), "Winner F", "Runner-up E", () => getWinnerOfGroup("F"), () => getRunnerUpOfGroup("E"), MatchType.roundOf16),
    "R16H": Match.knockout("R16H", DateTime.utc(2022, 12, 6, 20-1, 00), "Winner H", "Runner-up G", () => getWinnerOfGroup("H"), () => getRunnerUpOfGroup("G"), MatchType.roundOf16),

    "QF1": Match.knockout("QF1", DateTime.utc(2022, 12,  9, 20-1, 00), "Winner R16A", "Winner R16C", () => getWinnerOfMatch("R16A"), () => getWinnerOfMatch("R16C"), MatchType.quarterFinals),
    "QF2": Match.knockout("QF2", DateTime.utc(2022, 12,  9, 16-1, 00), "Winner R16E", "Winner R16G", () => getWinnerOfMatch("R16E"), () => getWinnerOfMatch("R16G"), MatchType.quarterFinals),
    "QF3": Match.knockout("QF3", DateTime.utc(2022, 12, 10, 20-1, 00), "Winner R16B", "Winner R16D", () => getWinnerOfMatch("R16B"), () => getWinnerOfMatch("R16D"), MatchType.quarterFinals),
    "QF4": Match.knockout("QF4", DateTime.utc(2022, 12, 10, 16-1, 00), "Winner R16F", "Winner R16G", () => getWinnerOfMatch("R16F"), () => getWinnerOfMatch("R16G"), MatchType.quarterFinals),
    
    "SF1": Match.knockout("SF1", DateTime.utc(2022, 12, 13, 20-1, 00), "Winner QF1", "Winner QF2", () => getWinnerOfMatch("QF1"), () => getWinnerOfMatch("QF2"), MatchType.semiFinals),
    "SF2": Match.knockout("SF2", DateTime.utc(2022, 12, 14, 20-1, 00), "Winner QF3", "Winner QF4", () => getWinnerOfMatch("QF3"), () => getWinnerOfMatch("QF4"), MatchType.semiFinals),
    
    "F": Match.knockout("F", DateTime.utc(2022, 12, 18, 16-1, 00), "Winner SF1", "Winner SF2", () => getWinnerOfMatch("SF1"), () => getWinnerOfMatch("SF1"), MatchType.wcFinal),
    "f": Match.knockout("f", DateTime.utc(2022, 12, 17, 16-1, 00), "Runner-up SF1", "Runner-up SF2", () => getLoserOfMatch("SF1"), () => getLoserOfMatch("SF2"), MatchType.bronzeFinal),
  };
}