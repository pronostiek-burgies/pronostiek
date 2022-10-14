import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:pronostiek/api/client.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/api/time_client.dart';
import 'package:pronostiek/controllers/base_page_controller.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/controllers/user_controller.dart';
import 'package:pronostiek/pages/base_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> initializeSettings() async {
    Dio _authClient = await dropboxAuthClient();
    DropboxClient _contentClient = Get.put(DropboxClient(_authClient));
    await _contentClient.refreshAccessToken();
    Repository _repo = Get.put(Repository(_contentClient.dio));
    UserController _userController = Get.put(UserController());
    TimeClient _timeClient = Get.put(TimeClient());
    BasePageController _basePageController = Get.put(BasePageController());
    Get.put(PronostiekController());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError) {
            return errorView(snapshot);
          } else {
            return const BasePage();
          }
        }
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Scaffold waitingView() {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Text('Loading...'),
        ],
      ),
    ));
  }
}
