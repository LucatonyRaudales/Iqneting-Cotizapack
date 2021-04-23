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
      required  this.id,
      required  this.collection,
      this.permissions,
      required  this.name,
      required  this.description,
      this.createAt,
      required  this.enable,
    });

    String id;
    String collection;
    Permissions? permissions;
    String name;
    String description;
    int? createAt;
    bool enable;

    factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        name: json["name"],
        description: json["description"],
        createAt: json["create_at"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "\u0024permissions": permissions!.toJson(),
        "name": name,
        "description": description,
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
