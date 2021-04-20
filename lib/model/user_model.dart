class UserModel {
    UserModel({
        this.id,
        this.name,
        this.registration,
        this.status,
        this.email,
        this.emailVerification,
        this.prefs,
        this.password,
        this.nickname
    });

    String? id;
    String? name;
    int? status;
    int? registration;
    String? email;
    bool? emailVerification;
    Prefs? prefs;
    String? password;
    String? nickname;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["\u0024id"],
        name: json["name"],
        registration: json["registration"],
        status: json["status"],
        email: json["email"],
        emailVerification: json["emailVerification"],
        prefs: Prefs.fromJson(json["prefs"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "name": name,
        "registration": registration,
        "status": status,
        "email": email,
        "emailVerification": emailVerification,
        "prefs": prefs!.toJson(),
        "password": password,
        "nickname": nickname
    };
}

class Prefs {
    Prefs();

    factory Prefs.fromJson(Map<String, dynamic> json) => Prefs(
    );

    Map<String, dynamic> toJson() => {
    };
}
