import 'dart:async';
import 'dart:convert';

import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductsCtrl extends GetxController{
  ProductRepository _productRepository = ProductRepository();
  ProductList productList = ProductList();
  bool haveProducts = true;

  @override
  void onInit() {
    print('products page');
    getProducts();
    super.onInit();
  }

  void getProducts()async{
    try{
      _productRepository.getProducts()
      .then((value){
        if(value == null){
          this.haveProducts = false;
          return update();
        }
        switch(value.statusCode){
          case 200:
          productList = ProductList.fromJson( value.data["documents"]);// value.data["documents"].map((i)=>ProductModel.fromJson(i)).toList(); 
          update();
          break;
          default:
          MyAlert.showMyDialog(title: 'Error', message: 'por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
              Get.back();
            });
          print(value.data);
          break;
        }
      });
    }catch(e){
      print('Error get products: $e');
    }
  }
}