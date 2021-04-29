import 'dart:async';
import 'dart:io';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/model/file.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/repository/customer.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/settings/get_image.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewCustomerCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
    File image = File('');
  /*ProductModel product = ProductModel(image: [], category: ProductCategory(
    name: "Seleccionar Categoría", 
    description: "", 
    enable: true,
    collection: "",
    id: "",
    ));*/
  CustomerRepository _customerRepository = CustomerRepository();
    CustomerModel customer = CustomerModel(address: '');
  
  late MyFile myFile;
  @override
  void onInit() {
    readUserData();
    //getProductCategory();
    super.onInit();
  }

  void readUserData()async{
    MyAccount myAccount;
    if(MyGetStorage().haveData(key: 'accountData')){
      myAccount = MyAccount.fromJson(MyGetStorage().readData(key: 'accountData'));
    }else{
      myAccount = (await AccountRepository().getAccount())!;
    }
      customer.userId = myAccount.id;
      print('ID del usuario ${myAccount.id}');
  }

  Future getImage() async {
        var img = await GetImage().getImage(source: ImageSource.gallery);
        if(img != null){
          image = img;
        update();
        }
  }

  void getAddress({required BuildContext context})async{
  final kInitialPosition =  LatLng(-33.8567844, 151.213108);
    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: 'AIzaSyCEKW1ZjGXOBqYaa94nmddouzv_shllRz0',
                          initialPosition: kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            customer.address = result.adrAddress;
                            Navigator.of(context).pop();
                          update();
                          },
                          //forceSearchOnZoomChanged: true,
                          //automaticallyImplyAppBarLeading: false,
                          //autocompleteLanguage: "ko",
                          //region: 'au',
                          //selectInitialPosition: true,
                          // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                          //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                          //   return isSearchBarFocused
                          //       ? Container()
                          //       : FloatingCard(
                          //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                          //           leftPosition: 0.0,
                          //           rightPosition: 0.0,
                          //           width: 500,
                          //           borderRadius: BorderRadius.circular(12.0),
                          //           child: state == SearchingState.Searching
                          //               ? Center(child: CircularProgressIndicator())
                          //               : RaisedButton(
                          //                   child: Text("Pick Here"),
                          //                   onPressed: () {
                          //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                          //                     //            this will override default 'Select here' Button.
                          //                     print("do something with [selectedPlace] data");
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //         );
                          // },
                          // pinBuilder: (context, state) {
                          //   if (state == PinState.Idle) {
                          //     return Icon(Icons.favorite_border);
                          //   } else {
                          //     return Icon(Icons.favorite);
                          //   }
                          // },
                        );
                      },
                    ),
                  );
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
      customer.createAt = DateTime.now().millisecond;
      customer.image = myFile.id;
      _customerRepository.saveDocument(customer)
      .then((value){
        if(value == null){
          this.btnController.error();
            MyAlert.showMyDialog(title: 'Error al guardar los datos', message: 'por favor, intenta de nuevo', color: Colors.red);
            return Timer(Duration(seconds:2), ()=> this.btnController.reset());
        }
        switch(value.statusCode){
          case 201:
            this.btnController.success();
            MyAlert.showMyDialog(title: 'Guardado exitósamente', message: '${customer.name} fué añadido sin problemas', color: Colors.green);
            Timer(Duration(seconds: 3), ()=> Get.back());
          break;
          default:
          MyAlert.showMyDialog(title: 'Error al guardar los datos', message: 'por favor, intenta de nuevo', color: Colors.red);
          print('sepa el error');
        }
      });
    } catch (e) {
      print('Error save data: $e');
    }
  }
/*
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
  }*/
}