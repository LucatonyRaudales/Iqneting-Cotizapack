import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductsCtrl extends GetxController {
  ProductRepository _productRepository = ProductRepository();
  ProductList productList = ProductList();
  ProductCategory? category = ProductCategory();
  bool haveProducts = true;

  @override
  void onInit() {
    category = Get.arguments;
    getProducts();
    super.onInit();
  }

  Future getProducts() async {
    try {
      _productRepository
          .getProductsByCategory(categoryID: category!.id!)
          .then((value) {
        if (value!.data["sum"] == 0) {
          this.haveProducts = false;
          return update();
        }
        switch (value.statusCode) {
          case 200:
            productList = ProductList.fromJson(value.data[
                "documents"]); // value.data["documents"].map((i)=>ProductModel.fromJson(i)).toList();
            update();
            break;
          default:
            MyAlert.showMyDialog(
                title: 'Error',
                message: 'por favor, intenta de nuevo',
                color: Colors.red);
            Timer(Duration(seconds: 3), () {
              Get.back();
            });
            print(value.data);
            break;
        }
      });
    } catch (e) {
      print('Error get products: $e');
    }
  }

  void deleteProduct({required String productID}) async {
    _productRepository.disableProduct(productID: productID).then((value) {
      if (value) {
        MyAlert.showMyDialog(
            title: 'Producto eliminado',
            message: 'el producto fué eliminado satisfactoriamente',
            color: Colors.green);
        return getProducts();
      } else {
        return MyAlert.showMyDialog(
            title: 'Error',
            message:
                'ha ocurrido un error inesperado, por favor intenta de nuevo',
            color: Colors.red);
      }
    });
  }
}
