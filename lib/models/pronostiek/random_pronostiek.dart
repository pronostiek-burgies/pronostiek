
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/team.dart';
import 'package:searchfield/searchfield.dart';

enum AnswerType {
  player,
  number,
  team,
}

enum ScoreCriterium {
  exact,
  closest,
}

class RandomPronostiek {
  late String question;
  late AnswerType type;
  late ScoreCriterium criterium;
  String? answer;

  RandomPronostiek(
    this.question,
    this.type,
    this.criterium
  );

  RandomPronostiek.fromJson(Map<String,dynamic> json) {
    question = json["question"] as String;
    type = AnswerType.values[(json["type"]) as int];
    criterium = ScoreCriterium.values[(json["criterium"]) as int];
    answer = json["answer"] as String?;
  }

  Map<String,dynamic> toJSON() {
    return {
      "question": question,
      "type": type.index,
      "criterium": criterium.index,
      "answer" : answer,
    };
  }
  
  static List<RandomPronostiek> getQuestions() {
    List<RandomPronostiek> questions = [];
    questions.add(RandomPronostiek("Which player received the most card per played minutes?", AnswerType.player, ScoreCriterium.exact));
    questions.add(RandomPronostiek("Which team will be last after the group phase (base on poinst, goal difference and goals scored)?", AnswerType.team, ScoreCriterium.exact));
    questions.add(RandomPronostiek("What percentage of penalties (in game of in shou-outs) will be scored", AnswerType.number, ScoreCriterium.closest));
    return questions;
  }

  Widget getListTile(TextEditingController controller, GlobalKey<FormState> formKey) {
    return ListTile(title:Row(
      children: [
        Expanded(child: Text(question)),
        getInputWidget(controller, formKey),
      ]
    ));
  }

  Widget getInputWidget(TextEditingController controller, GlobalKey<FormState> formKey) {
    switch (type) {
      case AnswerType.number:
        return SizedBox(
          width: Get.textTheme.bodyText1!.fontSize!*15,
          child: TextFormField(
            controller: controller,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(counterText: "", isDense: true),
            textAlign: TextAlign.left,
          )
        );
      case AnswerType.team:
        Map<String, Team> teams = Get.find<MatchController>().teams;
        return SizedBox(
            width: Get.textTheme.bodyText1!.fontSize!*15,
            child: SearchField<Team>(
              validator: (state) {
                if (state == null || state == "") {return null;}
                if (!teams.values.map((e) => e.name).contains(state)) {
                  return 'Please Enter a valid Team';
                }
              },
              controller: controller,
              suggestions: teams.values.map((Team team) => SearchFieldListItem<Team>(
                team.name,
                item: team,
              )).toList(),
            )
          );
      case AnswerType.player:
        List<String> players = Get.find<MatchController>().players;
        return SizedBox(
            width: Get.textTheme.bodyText1!.fontSize!*15,
            child: SearchField<Team>(
              validator: (state) {
                if (state == null || state == "") {return null;}
                if (!players.contains(state)) {
                  return 'Please Enter a valid Team';
                }
              },
              controller: controller,
              suggestions: Get.find<MatchController>().players.map((String player) => SearchFieldListItem<Team>(
                player,
              )).toList(),
            )
          );
      default:
      return const Text("");
    }
  }

}
