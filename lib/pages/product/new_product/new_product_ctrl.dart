import 'dart:async';
import 'dart:io';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/file.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/settings/get_image.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NewProductCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
    File image = File('');
  ProductModel product = ProductModel(image: [], category: ProductCategory(
    name: "Seleccionar Categoría", 
    description: "", 
    enable: true,
    collection: "",
    id: "",
    ));
  ProductRepository _productRepository = ProductRepository();
  ListProductCategory listProductCategory = ListProductCategory();
  
  var arguments = Get.arguments;
  bool isUpdate = false;

  final picker = ImagePicker();
  late MyFile myFile;
  @override
  void onInit() {
    _init();
    super.onInit();
  }


  _init()async{
    if(arguments["editData"]){
      isUpdate = true;
      if(arguments["data"] != null){
        product = arguments["data"];
      }
    }
    await readUserData();
    getProductCategory();
  }

  Future readUserData()async{
    MyAccount myAccount;
    if(MyGetStorage().haveData(key: 'accountData')){
      myAccount = MyAccount.fromJson(MyGetStorage().readData(key: 'accountData'));
    }else{
      myAccount = (await AccountRepository().getAccount())!;
    }
      product.userId = myAccount.id;
      print('ID del usuario ${myAccount.id}');
  }


  Future getImage({required ImageSource source}) async {
        var img = await GetImage().getImage(source: source);
        if(img != null){
          image = img;
        update();
        }
  }
  
  void saveData()async{
    try {
      var imgres = await MyStorage().postFile(file: image);
      if(imgres != null){
        myFile = MyFile.fromJson(imgres.data);
      }else{
        btnController.error();
        MyAlert.showMyDialog(title: 'Error al guardar la imagen', message: 'por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
                btnController.reset();
            });
        return print('culiao');
      }
      product.image!.add(myFile.id!);
      _productRepository.saveDocument(data: product.toJson())
      .then((value){
        switch(value!.statusCode){
          case 201:
            this.btnController.success();
            MyAlert.showMyDialog(title: 'Guardado exitósamente', message: '${product.name} fué añadido sin problemas', color: Colors.green);
            Timer(Duration(seconds: 3), ()=> Get.back());
          break;
          default:
          MyAlert.showMyDialog(title: 'Error al guardar los datos', message: 'por favor, intenta de nuevo', color: Colors.red);
          print('sepa el error');
        }
      });
    } catch (e) {
      btnController.error();
        MyAlert.showMyDialog(title: 'Error al guardar los datos', message: e.toString(), color: Colors.red);
            Timer(Duration(seconds: 3), (){
                btnController.reset();
            });
      print('Error save data: $e');
    }
  }

  void getProductCategory(){
    _productRepository.getProductsCategories()
    .then((value){
      if(value == null){
        MyAlert.showMyDialog(title: 'Error!', message: 'hubo un problema al obtener algunos datos necesario, intenta de nuevo', color: Colors.red);
        return Timer(Duration(seconds: 3), ()=> Get.back());
      }
      listProductCategory = value;
      update();
    });
  }



    void showPicker(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: listProductCategory.listProductCategory!.isNotEmpty ? ListView.builder(
                    itemCount: listProductCategory.listProductCategory!.length,
                    itemBuilder: (ctx, index){
                      return InkWell(
                        onTap: (){
                          product.category = listProductCategory.listProductCategory![index];
                          update();
                          Navigator.pop(context);
                          },
                        child: ListTile(
                          trailing: new Icon(LineIcons.plus, color: color500,),
                          title: new Text(listProductCategory.listProductCategory![index].name, style: subtitulo,),
                          subtitle: new Text(listProductCategory.listProductCategory![index].description, style: body2,),
                        ),
                      );
                    })
                    : new Center(
                      child: new Text('Cargando')
                    ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }
}