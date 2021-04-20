
class MyFile {
    MyFile({
        this.id,
        this.permissions,
        this.name,
        this.dateCreated,
        this.signature,
        this.mimeType,
        this.sizeOriginal,
    });

    String? id;
    Permissions? permissions;
    String? name;
    int? dateCreated;
    String?signature;
    String? mimeType;
    int? sizeOriginal;

    factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
        id: json["\u0024id"],
        permissions: Permissions.fromJson(json["\u0024permissions"]),
        name: json["name"],
        dateCreated: json["dateCreated"],
        signature: json["signature"],
        mimeType: json["mimeType"],
        sizeOriginal: json["sizeOriginal"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024permissions": permissions!.toJson(),
        "name": name,
        "dateCreated": dateCreated,
        "signature": signature,
        "mimeType": mimeType,
        "sizeOriginal": sizeOriginal,
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
