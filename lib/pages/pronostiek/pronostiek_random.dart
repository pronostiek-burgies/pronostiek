
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class PronostiekRandom extends StatelessWidget {
  const PronostiekRandom({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(builder: (controller) {
      if (controller.pronostiek == null) {
        return const CircularProgressIndicator();
      }
      return getRandom(controller);
    });
  }

  Widget getRandom(PronostiekController controller) {
    bool pastDeadline = controller.utcTime.isAfter(controller.deadlineRandom);
    int filledIn = controller.pronostiek!.random.fold(0, (int v, RandomPronostiek e) => (e.answer != null && e.answer != "") ? v+1 : v);
    return Column(children: [
      PronostiekPage.pronostiekHeader("Random Questions", controller.deadlineRandom, controller.pronostiek!.random.length, filledIn, pastDeadline, 0),
      Form(
        autovalidateMode: AutovalidateMode.always,
        key: controller.randomFormKey,
        child: Expanded(child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.pronostiek!.random.length*2,
          itemBuilder: ((context, index) {
            if (index%2 == 0) {
              return controller.pronostiek!.random[index>>1].getListTile(controller.textControllersRandom[index>>1], controller.randomFormKey, controller, pastDeadline);
            }
            return const Divider();
          }),
        ))
      )
    ]);
  }

}