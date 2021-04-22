class Session {
    Session({
        this.userId,
        this.expire,
        this.ip,
        this.countryCode,
        this.countryName,
        this.current,
    });

    String? userId;
    int? expire;
    String? ip;
    String? countryCode;
    String? countryName;
    bool? current;

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        userId: json["\u0024id"],
        expire: json["expire"],
        ip: json["ip"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        current: json["current"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "expire": expire,
        "ip": ip,
        "countryCode": countryCode,
        "countryName": countryName,
        "current": current,
    };
}
