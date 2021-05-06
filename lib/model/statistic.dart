
class Statistic {
    Statistic({
        this.id,
        this.collection,
        this.permissions,
        this.userId,
        this.quotesSent = 0,
        this.quotesCanceled = 0,
        this.myCategories = 0,
        this.myProducts = 0,
        this.myClients = 0,
        this.totalQuotes = 0
    });

    String? id;
    String? collection;
    Permissions? permissions;
    String? userId;
    int quotesSent;
    int quotesCanceled;
    int myCategories;
    int myProducts;
    int myClients;
    int totalQuotes;

    factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        id: json["\u0024id"],
        collection: json["\u0024collection"],
        permissions: json["\u0024permissions"] != null ? Permissions.fromJson(json["\u0024permissions"]) : null,
        userId: json["userID"],
        quotesSent: json["quotesSent"],
        quotesCanceled: json["quotesCanceled"],
        myCategories: json["myCategories"],
        myProducts: json["myProducts"],
        myClients: json["myClients"],
        totalQuotes: json["totalQuotes"]
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024collection": collection,
        "\u0024permissions": permissions != null ? permissions!.toJson() : null,
        "userID": userId,
        "quotesSent": quotesSent,
        "quotesCanceled": quotesCanceled,
        "myCategories": myCategories,
        "myProducts": myProducts,
        "myClients": myClients,
        "totalQuotes": totalQuotes
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