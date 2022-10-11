import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/user_controller.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool busy = false;
  UserController userController = Get.find();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() {
    if (loginFormKey.currentState!.validate()) {
      busy = true;
      update();
      userController
          .login(
            usernameController.text,
            passwordController.text,
          ).then((auth) {
              busy = false;
              update();
              passwordController.clear();
          });

    }
  }
}
