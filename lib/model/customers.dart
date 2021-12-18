class CustomerList {
  late final List<CustomerModel>? customers;
  CustomerList({this.customers});

  factory CustomerList.fromJson(List<dynamic> parsedJson) {
    List<CustomerModel> customer =
        parsedJson.map((i) => CustomerModel.fromJson(i)).toList();

    return new CustomerList(
      customers: customer,
    );
  }
}

class CustomerModel {
  CustomerModel({
    this.id,
    this.rfc,
    this.collection,
    this.permissions,
    this.userId,
    this.name,
    this.createAt,
    this.email,
    this.phone,
    this.address,
    this.notes,
    this.image,
  });

  String? id;
  String? rfc;
  String? collection;
  Permissions? permissions;
  String? name;
  String? userId;
  int? createAt;
  String? email;
  String? phone;
  String? address;
  String? notes;
  String? image;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["\u0024id"] == null ? null : json["\u0024id"],
        collection:
            json["\u0024collection"] == null ? null : json["\u0024collection"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        userId: json["userID"],
        rfc: json["rfc"] ?? null,
        createAt: json["create_at"],
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"] == null ? null : json["address"],
        notes: json["notes"] == null ? null : json["notes"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id == null ? null : id,
        "\u0024collection": collection == null ? null : collection,
        //"\u0024permissions": permissions!.toJson(),
        "userID": userId,
        "rfc": rfc,
        "name": name == null ? null : name,
        "create_at": createAt,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "address": address == null ? null : address,
        "notes": notes == null ? null : notes,
        "image": image == null ? null : image,
        "enable": true,
        "\u0024permissions": permissions == null ? null : permissions!.toJson(),
      };
}

class Permissions {
  Permissions({
    this.read,
    this.write,
  });

  List<String>? read;
  List<String>? write;

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        read: List<String>.from(json["read"].map((x) => x)),
        write: List<String>.from(json["write"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "read": List<dynamic>.from(read!.map((x) => x)),
        "write": List<dynamic>.from(write!.map((x) => x)),
      };
}
