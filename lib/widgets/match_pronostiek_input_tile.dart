
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/icon_image_provider.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/widgets/possible_points.dart';

class MatchPronostiekInputTile extends StatefulWidget {
  final MatchPronostiek matchPronostiek;
  List<TextEditingController> controllers;
  bool disabled;
  PronostiekController controller;
  MatchPronostiekInputTile(this.matchPronostiek, this.controllers, this.disabled, this.controller, {super.key});

  @override
  State<MatchPronostiekInputTile> createState() => _MatchPronostiekInputTileState();
}

class _MatchPronostiekInputTileState extends State<MatchPronostiekInputTile> {
  late final Match match = Get.find<MatchController>().matches[widget.matchPronostiek.matchId]!;
  bool? winner;
  @override
  initState() {
    winner = widget.matchPronostiek.winner;
    super.initState();
  }

  updateMatchWinner(bool? newWinner, String matchId) {
    setState(() {
      winner = newWinner;
    });
    widget.controller.updateMatchWinner(newWinner, match.id);
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = widget.controllers;
    bool? winnerByGoals() {
      if (controllers[1].text == "" || controllers[0].text == "") {return null;}
      return int.parse(controllers[0].text) >= int.parse(controllers[1].text);
    }
    bool scoreDraw = controllers[0].text == controllers[1].text;
    MatchPronostiek matchPronostiek = widget.matchPronostiek;
    return ListTile(
      title: Row(
        children: [
          Text(matchPronostiek.matchId),
          const SizedBox(width: 8.0,),
          Expanded(child: Row(children: [
            if (match.home != null) ... [
              Expanded(child: match.home!.getWidget())
            ] else ...[
              Text(match.linkHome!, style: TextStyle(fontWeight: (!widget.disabled && match.knockout && (winner ?? false)) ? FontWeight.bold: FontWeight.normal),),
            ],
          ])),
          IntrinsicHeight(child: Row(
            children: [
              if (widget.disabled) ...[
                match.getScoreBoardMiddle(),
                VerticalDivider(color: wcRed, thickness: 1.0),
              ],          
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (match.knockout && winner != null) ... [
                    Switch(
                      value: !(winner!),
                      inactiveTrackColor: wcRed[200],
                      activeTrackColor: wcRed[200],
                      inactiveThumbColor: wcRed,
                      activeColor: wcRed,
                      activeThumbImage: IconImageProvider(Icons.emoji_events),
                      inactiveThumbImage: IconImageProvider(Icons.emoji_events),
                      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return wcRed[500];
                        }
                          return wcRed;
                        }),
                      onChanged: widget.disabled ? null : scoreDraw ? (v) => updateMatchWinner(!v, match.id) : null,
                    ),
                  ],
                  Row(children: [
                    SizedBox(
                      width: 24,
                      child: TextFormField(
                        controller: controllers.first,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: "", isDense: true),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (v) => updateMatchWinner(winnerByGoals(), match.id),
                        readOnly: widget.disabled,
                      )
                    ),
                    const Text("-"),
                    SizedBox(
                      width: 24,
                      child: TextFormField(
                        controller: controllers.last,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: "", isDense: true),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (v) => updateMatchWinner(winnerByGoals(), match.id),
                        readOnly: widget.disabled,
                      )
                    )
                  ],),
                ],
              ),
              if (!widget.disabled) ...[
              IconButton(
                onPressed: () {Get.defaultDialog(
                  title: "How to earn points?",
                  content: PossiblePointsWidget(int.tryParse(controllers[0].text), int.tryParse(controllers[1].text), match),
                );},
                icon: const Icon(Icons.help_outline)
              )
              ],
            ]
          )),

          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (match.away != null) ... [
                Expanded(child: match.away!.getWidget(flagFirst: false))
              ] else ...[
                Text(match.linkAway!, style: TextStyle(fontWeight: (!widget.disabled && match.knockout && !(winner ?? true)) ? FontWeight.bold: FontWeight.normal),),
              ],
              if (widget.disabled) ... [
                IntrinsicHeight(child: Row(children: [
                  VerticalDivider(color: wcRed, thickness: 1.0),
                  Tooltip(
                    richMessage: TextSpan(children: [
                      const TextSpan(text: "Points\n",style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: "= floor(("),
                      const TextSpan(text: "Base Points",style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " + "),
                      const TextSpan(text: "Bonus Points",style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ") x "),
                      const TextSpan(text: "Match Type Multiplier", style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ")\n"),
                      const TextSpan(text: "= floor(("),
                      TextSpan(text: "${matchPronostiek.getPronostiekBasePoints()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " + "),
                      TextSpan(text: "${matchPronostiek.getPronostiekBonusPoints()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ") x "),
                      TextSpan(text: "${MatchPronostiek.matchTypeMultiplier[match.type]!}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: ")\n"),
                      TextSpan(text: "= ${matchPronostiek.getPronostiekPoints()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    child: Text("Pts: ${matchPronostiek.getPronostiekPoints() ?? "?"}"))
                ],))
              ]
            ]
          )),
        ]
      ),
    );
  }
}