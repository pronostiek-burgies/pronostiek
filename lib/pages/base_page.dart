import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/base_page_controller.dart';
import 'package:pronostiek/pages/dashboard_page.dart';
import 'package:pronostiek/pages/drawer.dart';
import 'package:pronostiek/pages/match_page.dart';
import 'package:pronostiek/pages/pronostiek_page.dart';
import 'package:pronostiek/pages/result_page.dart';
import 'package:pronostiek/pages/rules_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Widget drawer = MyDrawer();
    return GetBuilder<BasePageController>(
        builder:(controller) => IndexedStack(
          index: controller.tabIndex,
          children: const [
            DashboardPage(drawer),
            PronostiekPage(drawer),
            ResultPage(drawer),
            RulesPage(drawer),
          ]
        )
      );
  }
}