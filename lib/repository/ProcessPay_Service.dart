import 'package:get/get_connect/connect.dart';

// const baseUrl = 'http://gerador-nomes.herokuap.com/nomes/10';

class BuyProvider extends GetConnect {
  Future<Response?> buyPackage({
    required String name,
    required String phone,
    required String email,
    required String itemName,
    required int unitprice,
    required int quantity,
    required String tokenID,
  }) async {
    try {
      var data =
          await post('https://cotizapack-conekta.herokuapp.com/payment', {
        "name": "$name",
        "phone": "$phone",
        "email": "$email",
        "itemName": "$itemName",
        "unit_price": unitprice,
        "quantity": quantity,
        "token_id": "$tokenID"
      });
      return data;
    } catch (e) {
      throw "Error: al Pagar $e";
    }
  }

// Get request
}
