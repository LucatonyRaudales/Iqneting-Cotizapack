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
    //this.name,
    //this.description,
    this.enable,
    this.nickname,
    this.logo,
    this.ceoName,
    this.businessName,
    this.phone,
    this.address,
    this.paymentUrl,
    this.createAt,
    required this.category,
  });

  String? id;
  String? collection;
  String? userID;
  String? rfc;
  // String? description;
  bool? enable;
  String? nickname;
  String? logo;
  String? ceoName;
  String? businessName;
  String? phone;
  String? address;
  String? paymentUrl;
  int? createAt;
  UserCategory category;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["\u0024id"] ?? '',
        collection: json["\u0024collection"] ?? '',
        rfc: json["name"] ?? '',
        //name: json["name"],
        userID: json["userID"] ?? '',
        //description: json["description"],
        enable: json["enable"] ?? '',
        nickname: json["nickname"] ?? '',
        logo: json["logo"] ?? '',
        ceoName: json["ceoName"] ?? '',
        businessName: json["businessName"] ?? '',
        phone: json["phone"] ?? '',
        address: json["address"] ?? '',
        paymentUrl: json["giro"] ?? '',
        createAt: json["create_at"] ?? '',
        category: UserCategory.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "name": rfc,
        "rfc": rfc,
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
        "giro": paymentUrl,
        "create_at": createAt,
        "category": category.toJson(),
      };
}
