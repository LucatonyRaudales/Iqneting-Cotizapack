import 'package:cotizapack/model/product_category.dart';

class ProductList{
  late final List<ProductModel>? products;
  ProductList({
     this.products
  });

  factory ProductList.fromJson(List<dynamic> parsedJson) {

    List<ProductModel> products = parsedJson.map((i)=>ProductModel.fromJson(i)).toList();

    return new ProductList(
      products: products,
    );
  }
}

class ProductModel {
    ProductModel({
        this.id,
        this.name,
        this.description,
        this.price,
        this.clientPrice,
        this.image,
        this.userId,
        this.collection,
        required this.category,
    });

    String? id;
    String? collection;
    String? name;
    String? description;
    double? price;
    double? clientPrice;
    List<String>? image;
    String? userId;
    ProductCategory? category;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["\u0024id"],
        collection: json["collection"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        clientPrice: json["clientPrice"].toDouble(),
        image: List<String>.from(json["images"].map((x) => x)),
        userId: json["userID"].toString(),
        category:  ProductCategory.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "name": name,
        "description": description,
        "price": price,
        "clientPrice": clientPrice,
        "images": List<dynamic>.from(image!.map((x) => x)),
        "userID": userId,
        "category": category!.toJson(),
    };
}
