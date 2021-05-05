class TokenReset {
    TokenReset({
        this.id,
        this.userId,
        this.secret,
        this.expire,
    });

    String? id;
    String? userId;
    String? secret;
    int? expire;

    factory TokenReset.fromJson(Map<String, dynamic> json) => TokenReset(
        id: json["\u0024id"],
        userId: json["userId"],
        secret: json["secret"],
        expire: json["expire"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "userId": userId,
        "secret": secret,
        "expire": expire,
    };
}
