import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/user_controller.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool busy = false;
  UserController userController = Get.find<UserController>();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      busy = true;
      update();
      bool auth = await userController.login(
            usernameController.text.trim(),
            passwordController.text.trim(),
          );
      busy = false;
      update();
      passwordController.clear();
      if (auth) {
        userController.toggleLogin();
      }
    }
  }
}
