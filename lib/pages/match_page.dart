import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/match_controller.dart';

class MatchPage extends StatelessWidget {
  final Widget drawer;
  const MatchPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      init: MatchController(),
      builder: (controller) {
        return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            title: const Text("Pronostiek WK Qatar"),
            actions: <Widget>[
              IconButton(onPressed: () => Get.find<MatchController>().getResults(), icon: const Icon(Icons.refresh)),
              IconButton(onPressed: () async => Get.find<Repository>().writeDropboxFile("/users/usernames.json", "[]").then((value) => print(value)), icon: const Icon(Icons.build)),

            ],
          ),
          body: controller.matches.isNotEmpty
            ? ListView.builder(
                itemCount: controller.matches.length*2,
                itemBuilder: ((context, index) {
                  List<String> keys = controller.getSortedKeys();
                  return index%2 == 0 ? controller.matches[keys[index>>1]]!.getListTile() : const Divider();
                }),
              )
            : const Center(child:Text("No matches available"))
        );
      }
    );
  }
}