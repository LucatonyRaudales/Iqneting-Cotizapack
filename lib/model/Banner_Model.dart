// To parse this JSON data, do
//
//     final bannersModel = bannersModelFromMap(jsonString);

import 'dart:convert';

class BannersModel {
  BannersModel({
    this.id,
    this.collection,
    this.permissions,
    this.title,
    this.description,
    this.image,
    this.createAt,
    this.enable,
    this.showAt,
  });

  String? id;
  String? collection;
  Permissions? permissions;
  String? title;
  String? description;
  String? image;
  int? createAt;
  bool? enable;
  int? showAt;

  factory BannersModel.fromJson(String str) =>
      BannersModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BannersModel.fromMap(Map<String, dynamic> json) => BannersModel(
        id: json["\u0024id"] == null ? null : json["\u0024id"],
        collection:
            json["\u0024collection"] == null ? null : json["\u0024collection"],
        permissions: json["\u0024permissions"] == null
            ? null
            : Permissions.fromMap(json["\u0024permissions"]),
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        createAt: json["create_at"] == null ? null : json["create_at"],
        enable: json["enable"] == null ? null : json["enable"],
        showAt: json["show_at"] == null ? null : json["show_at"],
      );

  Map<String, dynamic> toMap() => {
        "\u0024id": id == null ? null : id,
        "\u0024collection": collection == null ? null : collection,
        "\u0024permissions": permissions == null ? null : permissions!.toMap(),
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "create_at": createAt == null ? null : createAt,
        "enable": enable == null ? null : enable,
        "show_at": showAt == null ? null : showAt,
      };
}

class Permissions {
  Permissions({
    this.read,
    this.write,
  });

  List<String>? read;
  List<String>? write;

  factory Permissions.fromJson(String str) =>
      Permissions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Permissions.fromMap(Map<String, dynamic> json) => Permissions(
        read: json["read"] == null
            ? null
            : List<String>.from(json["read"].map((x) => x)),
        write: json["write"] == null
            ? null
            : List<String>.from(json["write"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "read": read == null ? null : List<dynamic>.from(read!.map((x) => x)),
        "write":
            write == null ? null : List<dynamic>.from(write!.map((x) => x)),
      };
}
