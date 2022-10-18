
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
  late String id;
  late String question;
  late AnswerType type;
  late ScoreCriterium criterium;
  String? answer;

  static Map<String,RandomPronostiek> questions = {
    "cards" : RandomPronostiek("cards", "Which player received the most card (at least 1) per played minutes?", AnswerType.player, ScoreCriterium.exact),
    "loser" : RandomPronostiek("loser", "Which team will be last after the group phase (base on poinst, goal difference and goals scored)?", AnswerType.team, ScoreCriterium.exact),
    "penalty" : RandomPronostiek("penalty", "What percentage of penalties (in game of in shou-outs) will be scored", AnswerType.number, ScoreCriterium.closest),
  };

  RandomPronostiek(
    this.id,
    this.question,
    this.type,
    this.criterium
  );

  RandomPronostiek.fromJson(Map<String,dynamic> json) {
    if (questions[json["id"]] == null) {print(json);}
    RandomPronostiek randomPronostiek = questions[json["id"]]!;
    id = randomPronostiek.id;
    question = randomPronostiek.question;
    type = randomPronostiek.type;
    criterium = randomPronostiek.criterium;
    answer = json["answer"] as String?;
  }

  Map<String,dynamic> toJson() {
    return {
      "id": id,
      "answer" : answer,
    };
  }
  
  static List<RandomPronostiek> getQuestions() {
    return questions.values.toList();
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
