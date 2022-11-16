import 'package:get/get.dart';
import 'package:pronostiek/pages/pronostiek/pronostiek_page.dart';

class PronostiekPageController extends GetxController {
  /// index of shown tab
  var tabIndex = 0;

  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
