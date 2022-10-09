
import 'package:flutter/material.dart';

class Team {
  String name;
  String shortName;
  String flagName;

  Team(
    this.name,
    this.shortName,
    this.flagName,
  );

  getFlag() {
    return Image.asset('icons/flags/png/$flagName.png', package: 'country_icons', height: 20,);
  }
}