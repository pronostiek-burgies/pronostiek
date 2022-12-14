import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pronostiek/api/client.dart';
import 'package:pronostiek/api/repository.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/models/user.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserController extends GetxController {
  User? user;
  bool detailsOpen = false;
  bool isLogged = false;

  final picker = ImagePicker();

  Color pickerColor = wcRed[900]!;

  bool loginOpen = false;
  bool registerOpen = false;

  Repository repo = Get.find<Repository>();
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 128,
  );
  // A random salt
  final nonce = [4,5,6];


  static UserController get to => Get.find<UserController>();

  UserController() {
  }

  Future<bool> tryLoginWithBrowserToken() async {
    if (!kIsWeb) {
      return false;
    }
    if (WebStorage.instance.username == null) {return false;}
    User? userTemp = await repo.loginUser(WebStorage.instance.username!, "maakt niet uit", token: true);
    if (userTemp != null) {
      user = userTemp;
      isLogged = true;
      saveUserToBrowser();
      await Get.find<PronostiekController>().initPronostiek();
      update();
      return true;
    }
    return false;
  }

  saveUserToBrowser() {
    if (kIsWeb) {
      WebStorage.instance.username = user!.username;
    }
  }

  logoutFromBrowser() {
    if (kIsWeb) {
      WebStorage.instance.username = null;
    }
  }

  void toggleLogin() {
    loginOpen = !loginOpen;
    update();
  }

  void toggleRegister() {
    registerOpen = !registerOpen;
    update();
  }

  void toggleDetailOpen() {
    detailsOpen = !detailsOpen;
    update();
  }

  void setPickerColor(Color color) {
    pickerColor = color;
    update();
  }

  Future<void> setColor(Color color) async {
    user!.color = color;
    await repo.saveUserDetails();
    update();
  }

  Future<bool> login(String username, String password) async {
    User? userTemp = await repo.loginUser(username, password);
    if (userTemp != null) {
      user = userTemp;
      isLogged = true;
      saveUserToBrowser();
      await Get.find<PronostiekController>().initPronostiek();
      update();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String firstname, String lastname, String password, String password2) async {
    User? userTemp = await repo.registerUser(username, firstname, lastname, password, password2);
    if (userTemp != null) {
      login(username, password);
      return true;
    }
    return false;
  }

  Future<List<int>> getPwDigest(String password) async {
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    return newSecretKeyBytes;
  }

  Future<bool> checkPassword(User user, String password) async {
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    if (newSecretKeyBytes.length != user.pwDigest.length) {
      return false;
    }
    for (int i=0; i<user.pwDigest.length; i++) {
      if (newSecretKeyBytes[i] != user.pwDigest[i]) {
        return false;
      }
    }
    return true;
  }

  logout() async {
    user = null;
    isLogged = false;
    logoutFromBrowser();
    update();
  }

}
