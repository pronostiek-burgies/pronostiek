import 'package:dio/dio.dart';
import 'package:pronostiek/api/dropbox.dart';

class Repository {
  Dio apiClient;
  //or Database
  //or Shared Preference, etc

  Repository(this.apiClient) {
    // initialize other sources if needed
  }

  Future<String> readDropboxFile(String pathToFile) async {
    Response response = await readFile(apiClient, pathToFile);
    return response.data;
  }
}
