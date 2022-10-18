import 'dart:convert';
import 'package:get/get.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/api/sportdataapi.dart';
import 'package:pronostiek/models/match.dart';

class MatchRepository {
  Repository repo = Get.find<Repository>();
  SportDataApiClient sportDataApiClient = SportDataApiClient();
  //or Database
  //or Shared Preference, etc

  final JsonDecoder decoder = const JsonDecoder();


  int? sportdataapiRemainingRequests;


  Future<bool> saveAllMatches(Map<String,dynamic> matches) {
    return repo.writeDropboxFile("/results/matches.json", jsonEncode(matches));
  }

  Future<void> getAllMatches(Map<String,Match> matches) async {
    sportdataapiRemainingRequests = int.tryParse(jsonDecode(await repo.readDropboxFile("/sportdataapi.json"))["remaining_requests"]);
    for (dynamic match in Map<String,dynamic>.from(jsonDecode(await repo.readDropboxFile("/results/matches.json"))).values) {
      Match.updateFromJson(match, matches);
    }
  }

  Future<void> updateStatus() async {
    sportdataapiRemainingRequests = await sportDataApiClient.getStatus();
    if (sportdataapiRemainingRequests == null) {return;}
    await repo.writeDropboxFile("/sportdataapi.json", '{"remaining_requests":"$sportdataapiRemainingRequests"}');
  }

  Future<void> fetchLiveMatchResults(Map<String,Match> matches, DateTime day) async {
    if (sportdataapiRemainingRequests == null) {
      await getAllMatches(matches);
      return;
    }
    // client data not up to date with dropbox -> first update from dropbox
    if ((int.tryParse(jsonDecode(await repo.readDropboxFile("/sportdataapi.json"))["remaining_requests"]) ?? 500) < sportdataapiRemainingRequests!) {
      await getAllMatches(matches);
    } else { // client data up to date with dropbox -> make api call to get live results
      await Future.wait([
        updateStatus(),
        sportDataApiClient.getMatches(day, wc: false).then((value) {
          List.from(value["data"]).forEach((v) {
            for (String k in matches.keys) {
              if (matches[k]?.sportDataApiId == v["match_id"]) {
                if (v["status_code"] == 1) {
                  matches[k]!.status = MatchStatus.inPlay;
                  matches[k]!.goalsHomeFT = v["stats"]["home_score"];
                  matches[k]!.goalsAwayFT = v["stats"]["away_score"];
                }
                continue;
              }
            }
          });
        })
      ]);
      saveAllMatches(matches);
    }

  }
  



}
