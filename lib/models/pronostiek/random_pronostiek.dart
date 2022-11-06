
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/team.dart';

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

  final int points = 20;

  late String id;
  late String question;
  late AnswerType type;
  late ScoreCriterium criterium;
  String? answer;

  static Map<String,RandomPronostiek> questions = {
    "cards_player" : RandomPronostiek("cards_player", "Which player received the most cards (at least 1) per played minutes?", AnswerType.player, ScoreCriterium.exact),
    "loser" : RandomPronostiek("loser", "Which team will be last after the group phase (base on points, goal difference and goals scored)?", AnswerType.team, ScoreCriterium.exact),
    "penalty" : RandomPronostiek("penalty", "What percentage of penalties (in game and in shout-outs) will be scored?", AnswerType.number, ScoreCriterium.closest),
    "goals_stoppage": RandomPronostiek("goals_stoppage", "How many goals will be scored in 90+ and 120+ stoppage time?", AnswerType.number, ScoreCriterium.closest),
    "total_card": RandomPronostiek("total_goals", "How many bookings will be given (red: 4, two yellows: 3, yellow: 1)?", AnswerType.number, ScoreCriterium.closest),
    "hazard": RandomPronostiek("hazard", "How many minutes will Eden Hazard play?", AnswerType.number, ScoreCriterium.closest),
    "top_scorer": RandomPronostiek("top_scorer", "Which player will be the top scorer?", AnswerType.player, ScoreCriterium.exact),
    "top_assists": RandomPronostiek("top_assists", "Which player will be the assist king?", AnswerType.player, ScoreCriterium.exact),
    "hattricks": RandomPronostiek("hattricks", "How many hattricks will be scored?", AnswerType.number, ScoreCriterium.closest),
    "own_goals": RandomPronostiek("own_goals", "How many own goals will be scored?", AnswerType.number, ScoreCriterium.closest),
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

  Widget getListTile(TextEditingController controller, GlobalKey<FormState> formKey, PronostiekController pronostiekController, bool pastDeadline) {
    return ListTile(title:Row(
      children: [
        Expanded(child: Text(question)),
        getInputWidget(controller, formKey, pronostiekController, pastDeadline),
      ]
    ));
  }

  Widget getInputWidget(TextEditingController controller, GlobalKey<FormState> formKey, PronostiekController pronostiekController, bool pastDeadline) {
    switch (type) {
      case AnswerType.number:
        return SizedBox(
          width: Get.textTheme.bodyLarge!.fontSize!*15,
          child: TextFormField(
            readOnly: pastDeadline,
            controller: controller,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(counterText: "", isDense: true),
            textAlign: TextAlign.left,
          )
        );
      case AnswerType.team:
        Map<String, Team> teams = Get.find<MatchController>().teams;
        return SizedBox(
          width: Get.textTheme.bodyLarge!.fontSize!*15,
          child: Autocomplete<Team>(
            initialValue: TextEditingValue(text: controller.text, ),
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
              readOnly: pastDeadline,
              focusNode: focusNode,
              controller: textEditingController,
              validator: (state) {
                if (state == null || state == "") {return null;}
                if (!teams.values.map((e) => e.name).contains(state)) {
                  return 'Please Enter a valid team';
                }
              },
            ),
            onSelected: (option) => controller.text = option.name,
            displayStringForOption: (Team option) => option.name,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<Team>.empty();
              }
              return teams.values.where((Team option) {
                return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
          )
        );
      case AnswerType.player:
        List<String> players = Get.find<MatchController>().players;
        return SizedBox(
          width: Get.textTheme.bodyLarge!.fontSize!*15,
          child: Autocomplete<String>(
            initialValue: TextEditingValue(text: controller.text),
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
              readOnly: pastDeadline,
              focusNode: focusNode,
              controller: textEditingController,
              validator: (state) {
                if (state == null || state == "") {return null;}
                if (!players.contains(state)) {
                  return 'Please Enter a valid player';
                }
              },
            ),
            onSelected: (option) => controller.text = option,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return players.where((String option) {
                return option.toLowerCase()
                    .toString()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
          )
        );
      default:
      return const Text("");
    }
  }

}
