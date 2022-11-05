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

  @override
  String toString() {
    return name;
  }

  Widget getWidget({bool flagFirst = true}) {
    Widget flag = getFlag();
    Widget text = Expanded(
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        textAlign: flagFirst ? TextAlign.start : TextAlign.end,
      )
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: flagFirst ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        flagFirst ? flag : text,
        const SizedBox(
          width: 5,
        ),
        flagFirst ? text : flag,
      ]);
  }

  getFlag({bool disabled = false}) {
    // return Flag.fromString(flagName.toUpperCase(), height: 20, width: 40);
    return Image.asset(
      'icons/flags/png/$flagName.png',
      package: 'country_icons',
      height: 20,
      width: 30,
      fit: BoxFit.fill,
      color: disabled ? const Color.fromARGB(255, 128, 128, 128) : null,
      colorBlendMode: disabled ? BlendMode.color : null,
    );
  }
}
