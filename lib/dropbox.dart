import 'package:dio/dio.dart';
String key = "sl.BQx10KzSw8t8rYmBMFvbr0ZY0-uUfhgdQj4VG2VUlAMNmZY_8RqRw-pfie1wd6gRvY-orKdqRmqlF2KWFh8B0IeCpLVsaBjcnehde1-RjHAvO3sWqLSOx9LtbgZA5LRmUJv0yys";
/*curl -X POST https://api.dropboxapi.com/2/files/list_folder \
    --header "Authorization: Basic <get app key and secret>" \
    --header "Content-Type: application/json" \
    --data "{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":\"/Homework/math\",\"recursive\":false}"
*/
void fetch() async {
  try {
    Response response = await Dio().post("https://api.dropboxapi.com/2/files/list_folder",
      options: Options(
        headers: {
          "Authorization": "Bearer $key",
          "Access-Control-Allow-Origin": "*", 
          "Access-Control-Allow-Credentials": "true", 
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        }
      ),
      data: {"path": ""}
    );
    print(response);
  } catch (e) {
    print(e);
  }
}