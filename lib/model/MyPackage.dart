import 'dart:convert';

import 'PakageModel.dart';

class Mypackage {
  Mypackage({
    this.id,
    this.collection,
    this.permissions,
    this.userId,
    this.package,
  });

  String? id;
  String? collection;
  Permissions? permissions;
  String? userId;
  Pakageclass? package;

  factory Mypackage.fromJson(String str) => Mypackage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mypackage.fromMap(Map<String, dynamic> json) => Mypackage(
        id: json["\u0024id"] == null ? null : json["\u0024id"],
        collection:
            json["\u0024collection"] == null ? null : json["\u0024collection"],
        permissions: json["\u0024permissions"] == null
            ? null
            : Permissions.fromMap(json["\u0024permissions"]),
        userId: json["userID"] == null ? null : json["userID"],
        package: json["package"] == null
            ? null
            : Pakageclass.fromMap(json["package"]),
      );

  Map<String, dynamic> toMap() => {
        "\u0024id": id == null ? null : id,
        "\u0024collection": collection == null ? null : collection,
        "\u0024permissions": permissions == null ? null : permissions!.toMap(),
        "userID": userId == null ? null : userId,
        "package": package == null ? null : package!.toMap(),
      };
}
