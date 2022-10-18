import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';


class ResultController extends GetxController {
  late Pronostiek solution;
  MatchController matchController = Get.find<MatchController>();


  static ResultController get to => Get.find<ResultController>();

  ResultController() {
    
  }

 

}