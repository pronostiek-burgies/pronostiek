import 'package:pronostiek/models/group.dart';
import 'package:pronostiek/models/team.dart';
import 'package:pronostiek/models/match.dart';

Map<String, Group> getGroups(Map<String, Team> teams, Map<String, Match> matches) {
  return {
    "A": Group("Group A",
      [teams["A1"]!, teams["A2"]!, teams["A3"]!, teams["A4"]!],
      [matches["A1"]!, matches["A2"]!, matches["A3"]!, matches["A4"]!, matches["A5"]!, matches["A6"]!]
    ),
    "B": Group("Group B",
      [teams["B1"]!, teams["B2"]!, teams["B3"]!, teams["B4"]!],
      [matches["B1"]!, matches["B2"]!, matches["B3"]!, matches["B4"]!, matches["B5"]!, matches["B6"]!]
    ),
    "C": Group("Group C",
      [teams["C1"]!, teams["C2"]!, teams["C3"]!, teams["C4"]!],
      [matches["C1"]!, matches["C2"]!, matches["C3"]!, matches["C4"]!, matches["C5"]!, matches["C6"]!]
    ),
    "D": Group("Group D",
      [teams["D1"]!, teams["D2"]!, teams["D3"]!, teams["D4"]!],
      [matches["D1"]!, matches["D2"]!, matches["D3"]!, matches["D4"]!, matches["D5"]!, matches["D6"]!]
    ),
    "E": Group("Group E",
      [teams["E1"]!, teams["E2"]!, teams["E3"]!, teams["E4"]!],
      [matches["E1"]!, matches["E2"]!, matches["E3"]!, matches["E4"]!, matches["E5"]!, matches["E6"]!]
    ),
    "F": Group("Group F",
      [teams["F1"]!, teams["F2"]!, teams["F3"]!, teams["F4"]!],
      [matches["F1"]!, matches["F2"]!, matches["F3"]!, matches["F4"]!, matches["F5"]!, matches["F6"]!]
    ),
    "G": Group("Group G",
      [teams["G1"]!, teams["G2"]!, teams["G3"]!, teams["G4"]!],
      [matches["G1"]!, matches["G2"]!, matches["G3"]!, matches["G4"]!, matches["G5"]!, matches["G6"]!]
    ),
    "H": Group("Group H",
      [teams["H1"]!, teams["H2"]!, teams["H3"]!, teams["H4"]!],
      [matches["H1"]!, matches["H2"]!, matches["H3"]!, matches["H4"]!, matches["H5"]!, matches["H6"]!]
    ),
  };
}