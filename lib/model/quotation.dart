import 'package:cotizapack/model/product.dart';

class QuotationModel{
    QuotationModel({
        this.id,
        this.title,
        this.description,
        this.expirationDate,
        this.subTotal,
        this.total,
        this.userId,
        this.collection,
        this.email,
        this.product,
        this.clientID, scope
    });

    String? id;
    String? collection;
    String? title = '';
    String? description = '';
    String? scope;
    int? expirationDate;
    double? subTotal;
    double? total;
    String? userId;
    String? email;
    ProductModel? product;
    String? clientID;

    factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
        id: json["\u0024id"],
        collection: json["collection"],
        title: json["title"],
        description: json["description"],
        scope: json['scope'],
        expirationDate: json["expirationDate"],
        subTotal: json["subTotal"].toDouble(),
        total: json['total'].toDouble(),
        userId: json["userID"].toString(),
        email: json["email"],
        product:  ProductModel.fromJson(json["product"]),
        clientID: json["clientID"]
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "title": title,
        "description": description,
        "scope": scope,
        "expirationDate": expirationDate,
        "subTotal": subTotal,
        "total": total,
        "userID": userId,
        "email": email,
        "product": product!.toJson(),
        "clientID": clientID
    };
}
