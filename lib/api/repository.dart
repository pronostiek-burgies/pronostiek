import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/dropbox.dart';
import 'package:pronostiek/controllers/user_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/user.dart';

class Repository {
  Dio apiClient;
  //or Database
  //or Shared Preference, etc

  Repository(this.apiClient) {
    // initialize other sources if needed
  }

  Future<String> readDropboxFile(String pathToFile) async {
    return await readFile(apiClient, pathToFile);
  }

  Future<bool> writeDropboxFile(String pathToFile, String data) async {
    return await writeFile(apiClient, pathToFile, data);
  }

  /// USER
  
  Future<User?> loginUser(String username, String password) async {
    List<dynamic> usernames = jsonDecode(await readDropboxFile("/users/usernames.json"));
    if (!usernames.contains(username)) {
      Get.defaultDialog(
        title: "Could not login.",
        content: Text("Username ($username) does not exist")
      );
      return null;
    }
    User user = User.fromJson(jsonDecode(await readDropboxFile("/users/$username.json")));
    bool checkPassword= await Get.find<UserController>().checkPassword(user, password);
    if (checkPassword) {
      return user;
    } else {
      Get.defaultDialog(
        title: "Could not login.",
        content: const Text("Password not correct")
      );
      return null;
    }
  }
  
  Future<User?> registerUser(String username, String firstname, String lastname, String password, String password2) async {
    if (password != password2) {
      Get.defaultDialog(
        title: "Could not register new user.",
        content: const Text("Password to not match.")
      );
      return null;
    }
    List<dynamic> usernames = jsonDecode(await readDropboxFile("/users/usernames.json"));
    if (usernames.contains(username)) {
      Get.defaultDialog(
        title: "Could not register new user.",
        content: Text("Username ($username) already exists.")
      );
      return null;
    }
    usernames.add(username);
    bool savedUsername = await writeDropboxFile("/users/usernames.json", jsonEncode(usernames));
    List<int> pwDigest = await Get.find<UserController>().getPwDigest(password);
    User newUser = User(username, firstname, lastname, pwDigest);
    bool savedUser = await writeDropboxFile("/users/$username.json", jsonEncode(newUser.toJSON()));
    bool savedPronostiek = await writeDropboxFile("/pronostiek/$username.json", jsonEncode(Pronostiek(username).toJSON()));
    if (savedUser && savedUsername && savedPronostiek) {
      return newUser;
    } else {
      Get.defaultDialog(
        title: "Could not register new user.",
        content: const Text("Try again")
      );
      return null;
    }
  }

  Future<Pronostiek?> getPronostiek() async {
    UserController userController = Get.find<UserController>();
    if (!userController.isLogged || userController.user == null) {
      Get.defaultDialog(
        title: "Could not find your pronostiek.",
        content: const Text("Try again")
      );
      return null;
    }
    String username = userController.user!.username;
    return Pronostiek.fromJson(jsonDecode(await readDropboxFile("/pronostiek/$username.json")));
  }

  Future<bool> savePronostiek(Pronostiek pronostiek) async {
    String username = Get.find<UserController>().user!.username;
    return await writeDropboxFile("/pronostiek/$username.json", jsonEncode(pronostiek.toJSON()));
  }


}
