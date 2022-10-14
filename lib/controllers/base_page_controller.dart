import 'package:get/get.dart';

class BasePageController extends GetxController {
  /// index of shown tab
  var tabIndex = 0;

  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
