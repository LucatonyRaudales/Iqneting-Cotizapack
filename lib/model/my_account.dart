
class MyAccount {
    MyAccount({
        this.id,
        this.name,
        this.registration,
        this.status,
        this.email,
        this.emailVerification,
        this.prefs,
    });

    String? id;
    String? name;
    int? registration;
    int? status;
    String? email;
    bool? emailVerification;
    Prefs? prefs;

    factory MyAccount.fromJson(Map<String, dynamic> json) => MyAccount(
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
    };
}

class Prefs {
    Prefs({
      required  this.theme,
      required  this.timezone,
    });

    String theme;
    String timezone;

    factory Prefs.fromJson(Map<String, dynamic> json) => Prefs(
        theme: json["theme"] ?? "",
        timezone: json["timezone"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "theme": theme,
        "timezone": timezone,
    };
}
