class Session {
    Session({
        this.id,
        this.userId,
        this.expire,
        this.ip,
        this.countryCode,
        this.countryName,
        this.current,
    });

    String? id;
    String? userId;
    int? expire;
    String? ip;
    String? countryCode;
    String? countryName;
    bool? current;

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["\u0024id"],
        userId: json["userId"],
        expire: json["expire"],
        ip: json["ip"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        current: json["current"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "userId": userId,
        "expire": expire,
        "ip": ip,
        "countryCode": countryCode,
        "countryName": countryName,
        "current": current,
    };
}
