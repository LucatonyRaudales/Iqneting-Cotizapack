import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsSearchController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  final formKey = GlobalKey<FormState>();
  RxList<ProductModel> products = <ProductModel>[].obs;
  bool haveProducts = true;
  RxString ordenprice = ''.obs;
  RxString typeopcion = ''.obs;
  RxString orderAZ = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getproduct();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getproduct() {
    _repository.getProductsByType().then(
      (value) {
        if (value == null) return;
        products.value = value.products!;
        update();
      },
    );
  }

  void createNewProduct() async {
    final response = await Get.toNamed(Routes.NEWPRODUCTS,
        arguments: {"editData": false, "data": null});

    if (response != null) getproduct();
  }

  searchProduct() {
    products.clear();
    var order =
        ordenprice.value == 'Mayor a menor' ? OrderType.desc : OrderType.asc;
    var type = typeopcion.value == 'Servicio' ? 1 : 0;
    _repository.searchProduct(order: order, type: type).then((value) {
      products.value = value!.products!;
      update();
    });
    update();
  }

  orderproductnamed({String? revers}) {
    products
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    if (revers! == "Z-A") products.value = products.reversed.toList();
    update();
  }
}
