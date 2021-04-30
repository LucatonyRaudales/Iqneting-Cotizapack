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
  CustomerRepository _customerRepository = CustomerRepository();
    CustomerModel customer = CustomerModel(address: 'mi dirección default para quitar luego');
  late MyFile myFile;

  var arguments = Get.arguments;
  bool isUpdate = false;

  @override
  void onInit() {
    _init();
    super.onInit();
  }


  _init(){
    if(arguments["editData"]){
      isUpdate = true;
      if(arguments["data"] != null){
        customer = arguments["data"];
      }
    }
    readUserData();
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
      customer.createAt = DateTime.now().millisecondsSinceEpoch;
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

  void updateMyData()async{
    try{
      if(image.path != ''){
        var imgres = await MyStorage().postFile(file: image);
        if(imgres != null){
          myFile = MyFile.fromJson(imgres.data);
          if(customer.image != null){
            var deleted = await MyStorage().deleteFile(fileId: customer.image!);
            print('Imagen vieja eliminado ${deleted.statusCode}');
            }
          customer.image = myFile.id;
        }else{
          btnController.error();
          MyAlert.showMyDialog(title: 'Error al guardar la imagen', message: 'por favor, intenta de nuevo', color: Colors.red);
              Timer(Duration(seconds: 3), (){
                  btnController.reset();
              });
          return print('culiao');
        }
      }
    _customerRepository.updateCustomer(customer: customer)
      .then((value){
        if(value){
          this.btnController.success();
          MyAlert.showMyDialog(title: 'Actualización exitósa', message: 'el cliente ${customer.name} fué actualizado exitósamente', color: Colors.green);
          return Timer(Duration(seconds: 3), ()=> Get.back());
        }else{
          this.btnController.error();
          MyAlert.showMyDialog(title: 'Error al actualizar el cliente', message: 'hubo un error inesperado, por favor intenta de nuevo', color: Colors.red);
          return Timer(Duration(seconds:2), ()=> this.btnController.reset());
        }
      });
    }catch(e){
      print('Error en actualizar customer: $e');
      MyAlert.showMyDialog(title: 'Error al actualizar el cliente', message: 'hubo un error inesperado, por favor intenta de nuevo', color: Colors.red);
    }
  }
}