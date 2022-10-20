import 'package:get/get.dart';
import 'package:pronostiek/controllers/match_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';


class UsersPronostiekController extends GetxController {
  late List<Pronostiek> usersPronostiek;
  MatchController matchController = Get.find<MatchController>();


  static UsersPronostiekController get to => Get.find<UsersPronostiekController>();

  UsersPronostiekController() {
    
  }

 

}