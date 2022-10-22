import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';

class KnockoutPage extends StatelessWidget {
  final MatchController controller;
  final horizontalScrollController = ScrollController();
  final verticalScrollController = ScrollController();

  
  KnockoutPage(this.controller, {Key? key}) : super(key: key);

  // TODO: properly dispose controllers

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        return Scrollbar(
          controller: horizontalScrollController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: Scrollbar(
              controller: verticalScrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.left,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: IntrinsicHeight(child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ["A","C","E","G","B","D","F","H"].map<Widget>((e) => controller.matches["R16$e"]!.getMatchCard()).toList(),
                    )),
                    Flexible(child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(flex: 1,child: SizedBox(height: 0,)),
                        Expanded(flex: 14,child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [1,2,3,4].map<Widget>((e) => controller.matches["QF$e"]!.getMatchCard()).toList(),)),
                        const Flexible(flex: 1,child: SizedBox(height: 0,)),
                      ]
                    )),
                    Flexible(child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(flex: 3,child: SizedBox(height: 0,)),
                        Expanded(flex: 10,child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [1,2].map<Widget>((e) => controller.matches["SF$e"]!.getMatchCard()).toList(),)),
                        const Flexible(flex: 3,child: SizedBox(height: 0,)),
                      ] 
                    )),
                    Flexible(child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(flex: 7, fit:FlexFit.tight, child: SizedBox(height: 0,)),
                        Flexible(flex: 2, child: controller.matches["F"]!.getMatchCard()),
                        Flexible(flex:7, fit:FlexFit.tight, child: Column(
                          children: [
                            const Flexible(flex: 5, fit:FlexFit.tight, child: SizedBox(height: 0,)),
                            Flexible(flex: 2, child: controller.matches["f"]!.getMatchCard()),
                          ],
                        ),)
                      ]
                    )),
                  ],
                )),
              )
            ),
          )
        ); 
      });
  }
}