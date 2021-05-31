import 'dart:convert';

import 'package:cotizapack/model/product.dart';

import 'customers.dart';

class QuotationsList {
  QuotationsList({this.quotations});
  List<QuotationModel>? quotations;

  factory QuotationsList.fromJson(List<dynamic> parsedJson) {
    List<QuotationModel> quotations =
        parsedJson.map((i) => QuotationModel.fromJson(i)).toList();

    return new QuotationsList(
      quotations: quotations,
    );
  }
}

QuotationModel quotationModelFromJson(String str) =>
    QuotationModel.fromJson(json.decode(str));

String quotationModelToJson(QuotationModel data) => json.encode(data.toJson());

class QuotationModel {
  QuotationModel({
    this.id,
    this.collection,
    this.permissions,
    this.title,
    this.description,
    this.quantity,
    this.expirationDate,
    this.subTotal,
    this.total,
    this.userId,
    this.createAt,
    this.status,
    this.product,
    this.images,
    this.customer,
  });

  String? id;
  String? collection;
  Permissions? permissions;
  String? title;
  String? description;
  int? quantity;
  int? expirationDate;
  CustomerModel? customer;
  double? subTotal;
  double? total;
  String? userId;
  int? createAt;
  int? status;
  ProductList? product;
  List<String?>? images;

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        title: json["title"],
        description: json["description"],
        quantity: json["quantity"].toInt(),
        expirationDate: json["expirationDate"].toInt(),
        subTotal: json["subTotal"].toDouble(),
        total: json["total"].toDouble(),
        userId: json["userID"],
        createAt: json["create_at"],
        customer: CustomerModel.fromJson(json["customer"]),
        status: json["status"],
        product: json["product"] != null
            ? ProductList.fromJson(json["product"])
            : ProductList(products: []),
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection ?? '',
        "\u0024permissions":
            permissions?.toJson() ?? Permissions(read: [], write: []),
        "title": title ?? '',
        "description": description ?? '',
        "quantity": quantity ?? 0,
        "expirationDate": expirationDate ?? 0,
        "subTotal": subTotal ?? 0,
        "total": total ?? 0,
        "userID": userId ?? '',
        "create_at": createAt ?? 0,
        "customer": customer?.toJson(),
        "status": status ?? 0,
        "product": List<dynamic>.from(
            product!.products!.map((e) => e.toJson()).toList()),
        "images": List<dynamic>.from(images!.map((e) => e).toList()),
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
