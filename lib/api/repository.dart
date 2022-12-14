import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/api/dropbox.dart';
import 'package:pronostiek/controllers/pronostiek_controller.dart';
import 'package:pronostiek/controllers/user_controller.dart';
import 'package:pronostiek/models/pronostiek/pronostiek.dart';
import 'package:pronostiek/models/pronostiek/random_pronostiek.dart';
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
  
  Future<List<String>> getUsernames() async {
    return List<String>.from(jsonDecode(await readDropboxFile("/users/usernames.json")));
  }

  Future<User> getUserDetails(String username) async {
    return User.fromJson(jsonDecode(await readDropboxFile("/users/$username.json")));
  }
  Future<void> saveProfilePicture(Uint8List data) async {
    UserController userController = Get.find<UserController>();
    writeDropboxFile("/users/${userController.user!.username}_picture", data.toString());
  }
  Future<Image?> getProfilePicture(User user) async {
    if (!user.customProfilePicture) {return null;}
    String bitmap = await readDropboxFile("/users/${user.username}_picture");
    if (bitmap.isEmpty) {return null;}
    return Image.memory(Uint8List.fromList(List.from(jsonDecode(bitmap))));
  }
  
  Future<User?> loginUser(String username, String password, {bool token=false}) async {
    List<dynamic> usernames = jsonDecode(await readDropboxFile("/users/usernames.json"));
    if (!usernames.contains(username) && !token) {
      Get.defaultDialog(
        title: "Could not login.",
        content: Text("Username ($username) does not exist")
      );
      return null;
    }
    User user = User.fromJson(jsonDecode(await readDropboxFile("/users/$username.json")));
    if (token) {
      user.profilePicture = await getProfilePicture(user);
      return user;
    }
    bool checkPassword= await Get.find<UserController>().checkPassword(user, password);
    if (checkPassword) {
      user.profilePicture = await getProfilePicture(user);
      return user;
    } else {
      Get.defaultDialog(
        title: "Could not login.",
        content: const Text("Password not correct")
      );
      return null;
    }
  }

  Future<void> saveUserDetails() {
    UserController userController = Get.find<UserController>();
    return writeDropboxFile("/users/${userController.user!.username}.json", jsonEncode(userController.user!.toJson()));
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
    bool savedUser = await writeDropboxFile("/users/$username.json", jsonEncode(newUser.toJson()));
    bool savedPronostiek = await writeDropboxFile("/pronostiek/$username.json", jsonEncode(Pronostiek(username).toJson()));
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

  Future<Map<String,Pronostiek>> getOtherUsersPronostiek(List<String> usernames) async {
    Map<String,Pronostiek> pronostieks = {};
    for (String username in usernames) {
      pronostieks[username] = Pronostiek.fromJson(jsonDecode(await readDropboxFile("/pronostiek/$username.json")));
    }
    return pronostieks;
  }

  Future<bool> savePronostiek(Pronostiek pronostiek) async {
    String username = Get.find<UserController>().user!.username;
    return await writeDropboxFile("/pronostiek/$username.json", jsonEncode(pronostiek.toJson()));
  }

  Future<List<RandomPronostiek>> getRandomSolution() async {
    String username = "admin";
    return Pronostiek.fromJson(jsonDecode(await readDropboxFile("/pronostiek/$username.json"))).random;
  }

  // Future<List<Pronostiek>> getOtherUsersPronostiek() async {
  //   UserController userController = Get.find<UserController>();
  //   if (!userController.isLogged || userController.user == null) {
  //     Get.defaultDialog(
  //       title: "Could not find your pronostiek.",
  //       content: const Text("Try again")
  //     );
  //     return null;
  //   }
  //   String username = userController.user!.username;
  //   return Pronostiek.fromJson(jsonDecode(await readDropboxFile("/pronostiek/$username.json")));
  // }

}
