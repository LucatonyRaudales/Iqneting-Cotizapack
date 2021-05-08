class FacebookData {
    FacebookData({
        this.id,
        this.email,
        this.name,
    });

    String? id;
    String? email;
    String? name;

    factory FacebookData.fromJson(Map<String, dynamic> json) => FacebookData(
        id: json["id"],
        email: json["email"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
    };
}
