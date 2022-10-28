import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class RulesPage extends StatelessWidget {
  final Widget drawer;
  const RulesPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Pronostiek WK Qatar"),
        // actions: <Widget>[
        // ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: Get.size.width*0.1),
        width: Get.size.width*0.6,
        child: const Markdown(data: 
"""
# Rules

Welcome to the only burgie worthy pronostiek, with point distribution based on mathemethics and Brent's opinion.

## 1. Matches
Points for matches are calculates as follows:  
**Points** = 	floor(floor(**Base Points** + **Bonus Points**) x **Mulitplier**)

- The **Multiplier** depends on the type of match:

|Match type|Multiplier|
|--|--|
|Group Matches|1.0|
|Round of 16|1.5|
|Quarter Finals|2.0|
|Semi-Finals|3.0|
|Final|4.0|
|Loser Final|1.0|

- **Base Points** are earned when you predict the correct winner (or draw):
  - For *group matches* you earn **2 points** for predicting the correct winner and **3 points** for predicting a draw.
  - For *knock-out matches* you earn **2 points** for predicting the correct winner after 90' and **6 points** for predicting a draw.

- **Bonus Points** are earn for predicting the correct (or being close to the correct) score after 90'. Bonus points for rare scores are higher than for normal scores.


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
      ),
    ));
  }

}