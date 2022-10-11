class User {
  late String username;
  late String firstname;
  late String lastname;
  late List<dynamic> pwDigest;

  User(
    this.username,
    this.firstname,
    this.lastname,
    this.pwDigest,
  );

  /// Constructor for a User instance from [json] (JSON format)
  User.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    pwDigest = json["pw_digest"];
  }

  Map<String,dynamic> toJSON() {
    return {
      "username": username,
      "firstname": firstname,
      "lastname": lastname,
      "pw_digest": pwDigest,
    };
  }
}