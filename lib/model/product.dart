import 'package:cotizapack/model/product_category.dart';

class ProductList {
  late final List<ProductModel>? products;
  ProductList({this.products});

  factory ProductList.fromJson(List<dynamic> parsedJson) {
    List<ProductModel> products =
        parsedJson.map((i) => ProductModel.fromJson(i)).toList();

    return new ProductList(
      products: products,
    );
  }
}

class ProductModel {
  ProductModel(
      {this.id,
      this.permissions,
      this.name,
      this.description,
      this.price,
      this.quantity,
      this.image,
      this.userId,
      this.collection,
      required this.category,
      this.enable,
      this.type});
  int? quantity;
  String? id;
  String? collection;
  Permissions? permissions;
  String? name;
  String? description;
  double? price;
  List<String>? image;
  String? userId;
  ProductCategory? category;
  bool? enable;
  int? type;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        name: json["name"],
        quantity: json["quantity"],
        description: json["description"],
        price: json["price"].toDouble(),
        image: List<String>.from(json["images"].map((x) => x)),
        userId: json["userID"].toString(),
        category: ProductCategory.fromJson(json["category"]),
        enable: json["enable"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "\u0024permissions": permissions != null ? permissions!.toJson() : null,
        "name": name,
        "description": description,
        "price": price,
        "images": List<dynamic>.from(image!.map((x) => x)),
        "userID": userId,
        "category": category!.toJson(),
        "enable": enable,
        "quantity": quantity,
        "type": type
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
