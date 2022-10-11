
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/match.dart';

Map<String,Match> getMatches(Map<String,Team> teams) {
  return {
    "A1": Match("A1", DateTime(2022, 11, 20, 17, 00), teams["A1"]!, teams["A2"]!, false),
    "A2": Match("A2", DateTime(2022, 11, 21, 17, 00), teams["A3"]!, teams["A4"]!, false),
    "A3": Match("A3", DateTime(2022, 11, 25, 14, 00), teams["A1"]!, teams["A3"]!, false),
    "A4": Match("A4", DateTime(2022, 11, 25, 17, 00), teams["A4"]!, teams["A2"]!, false),
    "A5": Match("A5", DateTime(2022, 11, 29, 16, 00), teams["A4"]!, teams["A1"]!, false),
    "A6": Match("A5", DateTime(2022, 11, 29, 16, 00), teams["A2"]!, teams["A3"]!, false),

    "B1": Match("B1", DateTime(2022, 11, 21, 14, 00), teams["B1"]!, teams["B2"]!, false),
    "B2": Match("B2", DateTime(2022, 11, 21, 20, 00), teams["B3"]!, teams["B4"]!, false),
    "B3": Match("B3", DateTime(2022, 11, 25, 20, 00), teams["B1"]!, teams["B3"]!, false),
    "B4": Match("B4", DateTime(2022, 11, 25, 11, 00), teams["B4"]!, teams["B2"]!, false),
    "B5": Match("B5", DateTime(2022, 11, 29, 20, 00), teams["B4"]!, teams["B1"]!, false),
    "B6": Match("B5", DateTime(2022, 11, 29, 20, 00), teams["B2"]!, teams["B3"]!, false),

    "C1": Match("C1", DateTime(2022, 11, 22, 11, 00), teams["C1"]!, teams["C2"]!, false),
    "C2": Match("C2", DateTime(2022, 11, 22, 17, 00), teams["C3"]!, teams["C4"]!, false),
    "C3": Match("C3", DateTime(2022, 11, 26, 20, 00), teams["C1"]!, teams["C3"]!, false),
    "C4": Match("C4", DateTime(2022, 11, 26, 14, 00), teams["C4"]!, teams["C2"]!, false),
    "C5": Match("C5", DateTime(2022, 11, 30, 20, 00), teams["C4"]!, teams["C1"]!, false),
    "C6": Match("C5", DateTime(2022, 11, 30, 20, 00), teams["C2"]!, teams["C3"]!, false),

    "D1": Match("D1", DateTime(2022, 11, 22, 20, 00), teams["D1"]!, teams["D2"]!, false),
    "D2": Match("D2", DateTime(2022, 11, 22, 14, 00), teams["D3"]!, teams["D4"]!, false),
    "D3": Match("D3", DateTime(2022, 11, 26, 17, 00), teams["D1"]!, teams["D3"]!, false),
    "D4": Match("D4", DateTime(2022, 11, 26, 11, 00), teams["D4"]!, teams["D2"]!, false),
    "D5": Match("D5", DateTime(2022, 11, 30, 16, 00), teams["D4"]!, teams["D1"]!, false),
    "D6": Match("D5", DateTime(2022, 11, 30, 16, 00), teams["D2"]!, teams["D3"]!, false),

    "E1": Match("E1", DateTime(2022, 11, 23, 17, 00), teams["E1"]!, teams["E2"]!, false),
    "E2": Match("E2", DateTime(2022, 11, 23, 14, 00), teams["E3"]!, teams["E4"]!, false),
    "E3": Match("E3", DateTime(2022, 11, 27, 20, 00), teams["E1"]!, teams["E3"]!, false),
    "E4": Match("E4", DateTime(2022, 11, 27, 11, 00), teams["E4"]!, teams["E2"]!, false),
    "E5": Match("E5", DateTime(2022, 12,  1, 20, 00), teams["E4"]!, teams["E1"]!, false),
    "E6": Match("E5", DateTime(2022, 12,  1, 20, 00), teams["E2"]!, teams["E3"]!, false),

    "F1": Match("F1", DateTime(2022, 11, 23, 20, 00), teams["F1"]!, teams["F2"]!, false),
    "F2": Match("F2", DateTime(2022, 11, 23, 11, 00), teams["F3"]!, teams["F4"]!, false),
    "F3": Match("F3", DateTime(2022, 11, 27, 14, 00), teams["F1"]!, teams["F3"]!, false),
    "F4": Match("F4", DateTime(2022, 11, 27, 17, 00), teams["F4"]!, teams["F2"]!, false),
    "F5": Match("F5", DateTime(2022, 12,  1, 16, 00), teams["F4"]!, teams["F1"]!, false),
    "F6": Match("F5", DateTime(2022, 12,  1, 16, 00), teams["F2"]!, teams["F3"]!, false),

    "G1": Match("G1", DateTime(2022, 11, 24, 20, 00), teams["G1"]!, teams["G2"]!, false),
    "G2": Match("G2", DateTime(2022, 11, 24, 11, 00), teams["G3"]!, teams["G4"]!, false),
    "G3": Match("G3", DateTime(2022, 11, 28, 17, 00), teams["G1"]!, teams["G3"]!, false),
    "G4": Match("G4", DateTime(2022, 11, 28, 11, 00), teams["G4"]!, teams["G2"]!, false),
    "G5": Match("G5", DateTime(2022, 12,  2, 20, 00), teams["G4"]!, teams["G1"]!, false),
    "G6": Match("G5", DateTime(2022, 12,  2, 20, 00), teams["G2"]!, teams["G3"]!, false),

    "H1": Match("H1", DateTime(2022, 11, 24, 17, 00), teams["H1"]!, teams["H2"]!, false),
    "H2": Match("H2", DateTime(2022, 11, 24, 14, 00), teams["H3"]!, teams["H4"]!, false),
    "H3": Match("H3", DateTime(2022, 11, 28, 20, 00), teams["H1"]!, teams["H3"]!, false),
    "H4": Match("H4", DateTime(2022, 11, 28, 14, 00), teams["H4"]!, teams["H2"]!, false),
    "H5": Match("H5", DateTime(2022, 12,  2, 16, 00), teams["H4"]!, teams["H1"]!, false),
    "H6": Match("H5", DateTime(2022, 12,  2, 16, 00), teams["H2"]!, teams["H3"]!, false),
  };
}