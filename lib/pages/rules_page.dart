import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pronostiek/models/match.dart';
import 'package:pronostiek/models/pronostiek/match_pronostiek.dart';

class RulesPage extends StatelessWidget {
  final Widget drawer;
  RulesPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Pronostiek WK Qatar"),
        // actions: <Widget>[
        // ],
      ),
      body: SingleChildScrollView(child: Container(
        padding: EdgeInsets.only(left: Get.size.width*0.1),
        width: Get.size.width*0.8,
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Markdown(data: rules[0], shrinkWrap: true,)),
            Image.asset("assets/bonus_points_eq.png", scale:1.75, alignment: Alignment.centerLeft,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(
              children: [
                const Text("With "),
                Image.asset("assets/P_single_team.png", scale:1.75),
                const Text(" :"),
              ],
            )),
            Flexible(child: Markdown(data: rules[1], shrinkWrap: true,)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(
              children: [
                const Text("With "),
                Image.asset("assets/P_both_teams.png", scale:1.75),
                const Text(" :"),
              ],
            )),
            Flexible(child: Markdown(data: rules[2], shrinkWrap: true,)),
            Flexible(child: Markdown(data: rules[3], shrinkWrap: true,)),
            Image.asset("assets/delta_factor.png", scale:1.25, alignment: Alignment.centerLeft,),
            Flexible(child: Markdown(data: rules[4], shrinkWrap: true,)),
            Flexible(child: Markdown(data: rules[5], shrinkWrap: true,)),
            
          ],
        ),
      )
    ));
  }

  List<String> rules = [
"""
# Rules

Welcome to the only burgie worthy pronostiek, with point distribution based on mathemethics and Brent's opinion.

## 1. Matches
Points for matches are calculates as follows:  
**Points** = 	floor(**Base Points** + **Bonus Points** x **Mulitplier**)

## 1.1 Multiplier
**Multiplier** depends on the type of match:

|Match type|Multiplier|
|--|--|
|Group Matches|${MatchPronostiek.matchTypeMultiplier[MatchType.group]!}|
|Round of 16|${MatchPronostiek.matchTypeMultiplier[MatchType.roundOf16]!}|
|Quarter Finals|${MatchPronostiek.matchTypeMultiplier[MatchType.quarterFinals]!}|
|Semi-Finals|${MatchPronostiek.matchTypeMultiplier[MatchType.semiFinals]!}|
|Final|${MatchPronostiek.matchTypeMultiplier[MatchType.wcFinal]!}|
|Loser Final|${MatchPronostiek.matchTypeMultiplier[MatchType.bronzeFinal]!}|

## 1.2 Base Points
**Base Points** are earned when you predict the correct winner (or draw):
- For *group matches* you earn **${MatchPronostiek.basePointsWin} points** for predicting the correct winner and **${MatchPronostiek.basePointsDraw} points** for predicting a draw.
- For *knock-out matches* you earn **${MatchPronostiek.basePointsWin} points** for predicting the correct winner after 90'.  
  If you correctly predict a draw after 90' you will earn **${MatchPronostiek.basePointsDrawKnockout} points** and if you also predict the correct winner after extra time/penalties you will earn **${MatchPronostiek.basePointsDrawKnockoutWinner} points** extra.

## 1.3 Bonus Points
**Bonus Points** are earned for predicting the correct (or being close to the correct) score after 90'. Bonus points for rare scores are higher than for normal scores.

""",
"""
|**#Goals**|**0**|**1**|**2**|**3**|**4**|**5**|**6**|**7**|**8**|**9**|
|--|--|--|--|--|--|--|--|--|--|--|
|**Points**|${MatchPronostiek.bonusPointsGoalsSingleTeam.join("|")}|
""",
"""
|**#Goals**|**0**|**1**|**2**|**3**|**4**|**5**|**6**|**7**|**8**|**9**|
|--|--|--|--|--|--|--|--|--|--|--|
|**Points**|${MatchPronostiek.bonusPointsTotalGoals.join("|")}|
**#Goals**|**10**|**11**|**12**|**13**|**14**|**15**|**16**|**17**|**18**|**19**|
|**Points**|${MatchPronostiek.bonusPointsTotalGoals.sublist(10).join("|")}|
""",
"""
With:
""",
"""
Where:
""",
"""
The pronostiek for the matches need to be filled in before the first match of the tournament stage:  
**Deadlines\***:
  - Group Phase: 20/11 17:00
  - Round of 16: 03/12 16:00
  - Quarter Finals: 09/12 16:00
  - Semi Finals: 13/12 20:00
  - Finals: 17/12 20:00


## 2. Progression

Predict for each round which teams will progress to the next tournament stage. You do not need to predict which teams play against each other.  
You can also fill in a not logical prediction (e.g. Brazil wins the World Cup, Argentina and Germany play the Final.)

- Predict which 16 teams will compete in the **Round of 16** (**2 pts**/correct team)
- Predict which 8 teams will compete in the **Quarter Finals** (**5 pts**/correct team)
- Predict which 4 teams will compete in the **Semi Finals** (**10 pts**/correct team)
- Predict which 2 teams will compete in the **World Cup Final** (**20 pts**/correct team)
- Predict which team will **win the World Cup** (**50 pts**/correct team)

**Deadline\***: 20/11 17:00

## 3. Random Questions

Anwser some random Questions about this World Cup, each question is worth **20 points**.
If the answer is a number you get 20 points if you are the closest to the correct answer

**Deadline\***: 20/11 17:00

*All times are Belgium times.

# General info


The fractions in the top left of every purple bar show how many item of your pronostiek are saved on the server. So when you fill in your pronostiek make sure to save your changes and check if the fractions have changed accordingly.
"""
];

}