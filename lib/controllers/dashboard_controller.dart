import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/controllers/user_controller.dart';

class DashboardController extends GetxController {
  final Repository repo = Get.find<Repository>();
  late List<String> usernames;

  Future<void> init() async {
    usernames = await repo.getUsernames();
  }


}
