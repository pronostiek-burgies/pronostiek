import 'package:get/get.dart';

class DrawerController extends GetxController {
  bool login = false;
  bool register = false;

  void toggleLogin() {
    login = !login;
    update();
  }

  void toggleRegister() {
    register = !register;
    update();
  }
  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
