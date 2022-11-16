import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';

class User {
  static Random random = Random();
  late String username;
  late String firstname;
  late String lastname;
  late List<dynamic> pwDigest;
  late bool admin;
  late bool customProfilePicture = false;
  Image? _profilePicture;
  late Color color = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));

  set profilePicture(Image? image) {
    if (image == null) {return;}
    _profilePicture = image;
    customProfilePicture = true;
  }

  User(
    this.username,
    this.firstname,
    this.lastname,
    this.pwDigest,
    {this.admin=false}
  );

  /// Constructor for a User instance from [json] (Json format)
  User.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    pwDigest = json["pw_digest"];
    admin = (json["admin"] ?? false) as bool;
    color = colorFromString(json["color"]);
    customProfilePicture = json["custom_profile_picture"] ?? false;
  }

  Map<String,dynamic> toJson() {
    return {
      "username": username,
      "firstname": firstname,
      "lastname": lastname,
      "pw_digest": pwDigest,
      "admin": admin,
      "color": color.toString(),
      "custom_profile_picture": customProfilePicture,
    };
  }

  static Color colorFromString(String? s) {
    if (s == null) {return Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));}
    String valueString = s.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  Widget getProfilePicture({bool border=true}) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color,
        border: border ? Border.all(color: color, width: 5.0) : null,
        shape: BoxShape.circle,
        image: _profilePicture == null ? null : DecorationImage(
          fit: BoxFit.fill,
          image: _profilePicture!.image,
        ),
      ),
      alignment: Alignment.center,
      child: _profilePicture != null ? null
        : Text(
        firstname.substring(0,1),
        style: const TextStyle(fontSize: 26, color: Colors.white),
      ),
    );
  }
}