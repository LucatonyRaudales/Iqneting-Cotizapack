
import 'dart:convert';

import 'categories.dart';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    UserData({
        this.id,
        this.collection,
        this.userID,
        //this.name,
        //this.description,
        this.enable,
        this.nickname,
        this.logo,
        this.ceoName,
        this.businessName,
        this.phone,
        this.address,
        this.giro,
        this.createAt,
        required this.category,
    });

    String? id;
    String? collection;
    String? userID;
    //String? name;
    // String? description;
    bool? enable;
    String? nickname;
    String? logo;
    String? ceoName;
    String? businessName;
    String? phone;
    String? address;
    String? giro;
    int? createAt;
    UserCategory category;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        //name: json["name"],
        userID: json["userID"],
        //description: json["description"],
        enable: json["enable"],
        nickname: json["nickname"],
        logo: json["logo"],
        ceoName: json["ceoName"],
        businessName: json["businessName"],
        phone: json["phone"],
        address: json["address"],
        giro: json["giro"],
        createAt: json["create_at"],
        category: UserCategory.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        //"name": name,
        "userID": userID,
        //"description": description,
        "enable": enable,
        "nickname": nickname,
        "logo": logo,
        "ceoName": ceoName,
        "businessName": businessName,
        "phone": phone,
        "address": address,
        "giro": giro,
        "create_at": DateTime.now().millisecondsSinceEpoch,
        "category": category.toJson(),
    };
}
