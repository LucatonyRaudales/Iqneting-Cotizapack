import 'dart:async';
import 'dart:io';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/file.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NewProductCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  late File image;
  ProductModel product = ProductModel();
  final picker = ImagePicker();
  late MyFile myFile;
  @override
  void onInit() {
    print('new Product');
    super.onInit();
  }

  Future getImage({required ImageSource source}) async {
    final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        update();
      }
      Get.back();
  }


  void saveData()async{
    btnController.reset();
    try {
      /*var imgres = await MyStorage().postFile(file: image);
      if(imgres.statusCode == 201){
        myFile = MyFile.fromJson(imgres.data);
      }else{
        btnController.error();
        MyAlert.showMyDialog(title: 'Error al guardar la imagen', message: 'por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
                btnController.reset();
            });
        return print('culiao');
      }*/
      product.image = "llorapormi";
      ProductRepository().saveDocument(data: product.toJson())
      .then((value){
        switch(value!.statusCode){
          case 201:
            MyAlert.showMyDialog(title: 'Guardado exitósamente', message: '${product.name} fué añadido sin problemas', color: Colors.green);
          break;
          default:
          MyAlert.showMyDialog(title: 'Error al guardar los datos', message: 'por favor, intenta de nuevo', color: Colors.red);
          print('sepa el error');
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}