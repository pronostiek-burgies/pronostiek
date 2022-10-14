import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/pronostiek.dart';

class PronostiekPage extends StatelessWidget {
  final Widget drawer;
  const PronostiekPage(this.drawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PronostiekController>(
      builder: (controller) {
        return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            title: const Text("Pronostiek WK Qatar"),
            actions: <Widget>[
              IconButton(onPressed: () => controller.save(), icon: const Icon(Icons.save)),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) => controller.changeTabIndex(value),
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.scoreboard),
                label: 'Matches',
              ),
              NavigationDestination(
                icon: Icon(Icons.merge_type),
                label: 'Progression',
              ),
              NavigationDestination(
                icon: Icon(Icons.star),
                label: 'Random',
              ),
            ]
          ),
          body: <Widget>[
            getMatches(controller),
            getProgression(controller),
            getRandom(controller),
          ][controller.tabIndex],
        );
      }
    );
  }

  Widget getMatches(PronostiekController controller) {
    if (controller.pronostiek == null) {
      return const CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: controller.groups.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                tileColor: const Color.fromARGB(255, 0, 195, 255),
                title: Text("${controller.groups[index].name} (deadline: ${DateFormat('dd/MM kk:mm').format(controller.groups[index].deadline)})"),
                trailing: controller.matchGroupCollapsed[index] ? const Icon(Icons.keyboard_arrow_up) : const Icon(Icons.keyboard_arrow_down),
                onTap: () => controller.toggleGroupCollapse(index),
              ),
              if (!controller.matchGroupCollapsed[index]) ...[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.pronostiek!.matches.length*2,
                  itemBuilder: (context, index) {
                    if (index%2 == 0) {
                      return controller.pronostiek!.matches[index>>1].getListTile();
                    } else {
                      return const Divider();
                    }
                  }
                )
              ],
            ]
          ),
        );
      }
    );
  }
  Widget getProgression(PronostiekController controller) {
    return Text("progression");
  }
  Widget getRandom(PronostiekController controller) {
    return Text("random");
  }


}