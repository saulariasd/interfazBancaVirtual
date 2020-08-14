import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.email,
    this.password,
    this.transferTo,
    this.value,
    this.entity,
  });

  String email;
  String password;
  String transferTo;
  String value;
  int entity;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
