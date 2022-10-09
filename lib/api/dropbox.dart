import 'package:dio/dio.dart';

Future<Response> readFile(Dio dio, String pathToFile) {
  return dio.get('/files/download',
    options: Options(
      headers: {
        "Dropbox-API-Arg": '{"path":"$pathToFile"}',
      }
    ));
}