import 'package:get/get.dart';
import 'package:pronostiek/controllers/pronostiek_page_controller.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class BasePageController extends GetxController {
  /// index of shown tab
  var tabIndex = 0;

  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    if (tabIndex == 0) {Get.find<PronostiekPageController>().changeTabIndex(0);}
    tabIndex = index;
    update();
  }
}
