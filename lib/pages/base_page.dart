import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/base_page_controller.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/pages/drawer.dart';
import 'package:pronostiek/pages/match_page.dart';
import 'package:pronostiek/pages/pronostiek_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Widget drawer = MyDrawer();
    return GetBuilder<BasePageController>(
        builder:(controller) => IndexedStack(
          index: controller.tabIndex,
          children: const [
            MatchPage(drawer),
            PronostiekPage(drawer),
            Text("Details"),
            Text("Rules"),
          ]
        )
      );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Pronostiek WK Qatar"),
    //     actions: <Widget>[
    //       IconButton(onPressed: () => Get.find<MatchController>().getResults(), icon: const Icon(Icons.refresh)),
    //       IconButton(onPressed: () async => Get.find<Repository>().writeDropboxFile("/users/usernames.json", "[]").then((value) => print(value)), icon: const Icon(Icons.build)),

    //     ],
    //   ),
    //   drawer: const MyDrawer(),
    //   body: GetBuilder<BasePageController>(
    //     builder:(controller) => IndexedStack(
    //       index: controller.tabIndex,
    //       children: const [
    //         MatchPage(),
    //         PronostiekPage(),
    //         Text("Details"),
    //         Text("Rules"),
    //       ]
    //     )
    //   ),
    // );
  }
}