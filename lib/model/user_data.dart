import 'package:cotizapack/model/PakageModel.dart';

import 'categories.dart';

class UserList {
  late final List<UserData>? users;
  UserList({this.users});

  factory UserList.fromJson(List<dynamic> parsedJson) {
    List<UserData> users = parsedJson.map((i) => UserData.fromJson(i)).toList();

    return new UserList(
      users: users,
    );
  }
}

class UserData {
  UserData({
    this.id,
    this.collection,
    this.userID,
    this.rfc,
    this.enable,
    this.nickname,
    this.logo,
    this.ceoName,
    this.businessName,
    this.packages,
    this.phone,
    this.address,
    this.paymentUrl,
    this.createAt,
    this.quotations,
    required this.category,
  });

  String? id;
  String? collection;
  String? userID;
  String? rfc;
  List<Pakageclass>? packages;
  bool? enable;
  String? nickname;
  String? logo;
  String? ceoName;
  String? businessName;
  String? phone;
  String? address;
  String? paymentUrl;
  int? createAt;
  int? quotations;
  UserCategory category;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["\u0024id"] ?? '',
        collection: json["\u0024collection"] ?? '',
        rfc: json["rfc"] ?? '',
        //name: json["name"],
        userID: json["userID"] ?? '',
        packages: json["packages"] == null
            ? <Pakageclass>[]
            : (json["packages"] as List)
                .map<Pakageclass>((e) => Pakageclass.fromMap(e))
                .toList(),
        enable: json["enable"] ?? true,
        nickname: json["nickName"] ?? '',
        logo: json["logo"] ?? '',
        ceoName: json["ceoName"] ?? '',
        businessName: json["businessName"] ?? '',
        phone: json["phone"] ?? '',
        address: json["address"] ?? '',
        paymentUrl: json["giro"] ?? '',
        createAt: json["create_at"] ?? 0,
        quotations: json["quotations"] ?? 0,
        category: UserCategory.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "rfc": rfc,
        "userID": userID,
        "enable": enable,
        "nickName": nickname,
        "logo": logo,
        "ceoName": ceoName,
        "businessName": businessName,
        "phone": phone,
        "address": address,
        "packages": packages == null
            ? []
            : List<dynamic>.from(packages!.map((e) => e.toMap()).toList()),
        "giro": paymentUrl,
        "create_at": createAt,
        "quotations": createAt,
        "category": category.toJson(),
      };
}
