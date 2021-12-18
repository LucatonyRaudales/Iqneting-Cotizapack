// To parse this JSON data, do
//
//     final creditCardModel = creditCardModelFromMap(jsonString);

import 'dart:convert';

class CreditCardModelLocal {
  CreditCardModelLocal({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
  });

  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;

  factory CreditCardModelLocal.fromJson(String str) =>
      CreditCardModelLocal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreditCardModelLocal.fromMap(Map<String, dynamic> json) =>
      CreditCardModelLocal(
        cardNumber: json["cardNumber"] == null ? null : json["cardNumber"],
        expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
        cardHolderName:
            json["cardHolderName"] == null ? null : json["cardHolderName"],
        cvvCode: json["cvvCode"] == null ? null : json["cvvCode"],
      );

  Map<String, dynamic> toMap() => {
        "cardNumber": cardNumber,
        "expiryDate": expiryDate,
        "cardHolderName": cardHolderName,
        "cvvCode": cvvCode,
      };
}
