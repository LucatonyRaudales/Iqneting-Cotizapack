class ListProductCategory{
  ListProductCategory({
    this.listProductCategory
  });
    List<ProductCategory>? listProductCategory;


  factory ListProductCategory.fromJson(List<dynamic> parsedJson) {

    List<ProductCategory> categories = parsedJson.map((i)=>ProductCategory.fromJson(i)).toList();

    return new ListProductCategory(
      listProductCategory: categories,
    );
  }
}

class ProductCategory {
    ProductCategory({
      this.id,
      this.collection,
      this.permissions,
      this.name,
      this.description,
      this.userID,
      this.createAt,
      this.enable,
    });

    String? id;
    String? collection;
    Permissions? permissions;
    String? name;
    String? description;
    String? userID;
    int? createAt;
    bool? enable;

    factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        name: json["name"],
        description: json["description"],
        userID: json["userID"],
        createAt: json["create_at"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "\u0024permissions": permissions != null ? permissions!.toJson() : null,
        "name": name,
        "description": description,
        "userID": userID,
        "create_at": createAt,
        "enable": enable,
    };
}

class Permissions {
    Permissions({
      required  this.read,
      required  this.write,
    });

    List<String> read;
    List<String> write;

    factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        read: List<String>.from(json["read"].map((x) => x)),
        write: List<String>.from(json["write"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "read": List<dynamic>.from(read.map((x) => x)),
        "write": List<dynamic>.from(write.map((x) => x)),
    };
}
