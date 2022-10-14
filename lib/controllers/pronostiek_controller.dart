import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/models/pronostiek.dart';

class PronostiekController extends GetxController {
  Pronostiek? pronostiek;
  Repository repo = Get.find<Repository>();
  /// index of shown tab
  var tabIndex = 0;
  Map<String,MatchGroup> dealines = {};
  List<String> matchIds = [];
  List<MatchGroup> groups = [];

  List<bool> matchGroupCollapsed = [];

  PronostiekController() {
    List<String> groupMatchesIds = ["A1","A3","A2","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6","E1","E2","E3","E4","E5","E6","F1","F2","F3","F4","F5","F6","G1","G2","G3","G4","G5","G6","H1","H2","H3","H4","H5","H6"];
    MatchGroup groupMatches = MatchGroup("Group Phase", DateTime(2022,11,10, 20, 00));
    matchIds.addAll(groupMatchesIds);
    groupMatchesIds.forEach((id) {dealines[id] = groupMatches;});
    groups.add(groupMatches);

    groups.forEach((element) {matchGroupCollapsed.add(true);});
  }


  /// sets [tabIndex] to [index] and updates view
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  void initPronostiek() {
    repo.getPronostiek().then((pronostiek) {
      this.pronostiek = pronostiek;
      update();
    });
  }

  void save() async {

  }

  void toggleGroupCollapse(int index) {
    matchGroupCollapsed[index] = !matchGroupCollapsed[index]; 
    update();
  }

}
