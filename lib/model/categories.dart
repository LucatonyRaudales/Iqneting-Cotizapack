class UserCategoryList{
  final List<UserCategory>? categories;
  UserCategoryList({
    this.categories
  });

  factory UserCategoryList.fromJson(List<dynamic> parsedJson) {

    List<UserCategory> categories = parsedJson.map((i)=>UserCategory.fromJson(i)).toList();

    return new UserCategoryList(
      categories: categories,
    );
  }
}

class UserCategory {
    UserCategory({
      required  this.id,
      required  this.collection,
      required  this.name,
      required  this.description,
      required  this.enable,
    });

    String id = "";
    String collection  = "";
    String name  = "Seleccionar categoría";
    String description  = "La categoría determinará tu sector";
    bool enable = true;

    factory UserCategory.fromJson(Map<String, dynamic> json) => UserCategory(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        name: json["name"],
        description: json["description"],
        enable: json["enable"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "\u0024permissions": {"read": ["*"], "write":  ["*"]},
        "name": name,
        "description": description,
        "enable": enable,
    };
}
