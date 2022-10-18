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


## 1. Matches
points for matches are calculates as follows:  
<to be determined>

The pronostiek for the matches need to be filled in before the first match of the tournament stage:  
**Deadlines\***:
  - Group Phase: 20/11 17:00
  - Group Phase: 20/11 17:00

  *All times are Belgium times.

## 2. Progression

## 3. Random Questions



# General info


The fractions in the top left of every purple bar show how many item of your pronostiek are saved on the server. So when you fill in your pronostiek make sure to save your changes and check if the fractions have changed accordingly.
"""
      ),
    ));
  }

}