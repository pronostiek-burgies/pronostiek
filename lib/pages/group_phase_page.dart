import 'package:flutter/material.dart';
import 'package:pronostiek/controllers/match_controller.dart';

class GroupPhasePage extends StatelessWidget {
  final MatchController controller;

  
  const GroupPhasePage(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.groups["A"]!.getGroupTable();
    
  }
}