
class ProductModel {
    ProductModel({
        this.id,
        this.name,
        this.description,
        this.price,
        this.clientPrice,
        this.image,
        this.userId,
    });

    String? id;
    String? name;
    String? description;
    double? price;
    double? clientPrice;
    String? image;
    String? userId;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["\u0024id"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        clientPrice: json["client_price"].toDouble(),
        image: json["image"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "name": name,
        "description": description,
        "price": price,
        "client_price": clientPrice,
        "image": image,
        "user_id": userId,
    };
}
