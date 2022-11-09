class User {
  late String username;
  late String firstname;
  late String lastname;
  late List<dynamic> pwDigest;
  late bool admin;

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
  }

  Map<String,dynamic> toJson() {
    return {
      "username": username,
      "firstname": firstname,
      "lastname": lastname,
      "pw_digest": pwDigest,
      "admin": admin,
    };
  }
}