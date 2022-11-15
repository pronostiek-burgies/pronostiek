import 'dart:convert';

import 'package:dio/dio.dart';

Future<String> readFile(Dio dio, String pathToFile) async {
  Response response;
  try {
    response = await dio.get('/files/download',
      options: Options(
        headers: {
          "Dropbox-API-Arg": '{"path":"$pathToFile"}',
        }
      )
    );
  return response.data;
  } catch (e) {
    return "";
  }
}

Future<bool> writeFile(Dio dio, String pathToFile, String data) async {
  Response response = await dio.post('/files/upload',
    options: Options(
      headers: {
        "Dropbox-API-Arg": '{"path":"$pathToFile", "mode":"overwrite"}',
        "Content-Type": "application/octet-stream",
      }
    ),
    data: data,
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
