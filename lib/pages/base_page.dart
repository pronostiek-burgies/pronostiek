import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/pages/drawer.dart';
import 'package:pronostiek/pages/match_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pronostiek WK Qatar"),
        actions: <Widget>[
          IconButton(onPressed: () => Get.find<MatchController>().getResults(), icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () async => Get.find<Repository>().writeDropboxFile("/users/usernames.json", "[]").then((value) => print(value)), icon: const Icon(Icons.build)),

        ],
      ),
      drawer: const MyDrawer(),
      body: const MatchPage()
    );
  }
}