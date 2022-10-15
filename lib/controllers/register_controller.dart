import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/controllers/user_controller.dart';

class RegisterController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  bool busy = false;
  UserController userController = Get.find();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    super.onClose();
  }

  /// Register function to check user input and call the register api
  void register() {
    if (loginFormKey.currentState!.validate()) {
      busy = true;
      update();
      userController
          .register(
            usernameController.text.trim(),
            firstnameController.text.trim(),
            lastnameController.text.trim(),
            passwordController.text.trim(),
            passwordController2.text.trim())
          .then((auth) {
            if (auth) {
              Get.snackbar('Register', 'Registration successful');
            }
              busy = false;
              update();
              passwordController.clear();
              passwordController2.clear();
          });

    }
  }
}
