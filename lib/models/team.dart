
import 'package:flutter/material.dart';

class Team {
  String name;
  String shortName;
  String flagName;
  String id;

  Team(
    this.name,
    this.shortName,
    this.flagName,
    this.id,
  );

  getFlag() {
    // return Flag.fromString(flagName.toUpperCase(), height: 20, width: 40);
    return Image.asset('icons/flags/png/$flagName.png', package: 'country_icons', height: 20, width: 30,);
  }
}