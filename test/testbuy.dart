import 'package:cotizapack/repository/ProcessPay_Service.dart';
import 'package:cotizapack/repository/categories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // test('proceso de Compra de un Pakete', () async {
  //   BuyProvider buyProvider = BuyProvider();

  //   var res = await buyProvider.buyPackage(
  //       name: "Luis ",
  //       phone: "+50487961495",
  //       email: "Luis@luis.com",
  //       itemName: "Paquete #1",
  //       unitprice: 50000,
  //       quantity: 1,
  //       tokenID: "tok_2q1LZ6NPX8m9Gjhvb");

  //   expect(res!.statusCode, 201, reason: "${res.body}");
  // });
  test('proceso de Compra de un Pakete', () async {
    CategoriesRepository categoriesRepository = CategoriesRepository();

    var res = await categoriesRepository.getCategories();

    expect(res.categories, res.categories?.isNotEmpty,
        reason: "${res.categories}");
  });
}
