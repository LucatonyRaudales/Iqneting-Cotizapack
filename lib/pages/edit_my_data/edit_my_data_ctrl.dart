import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:cotizapack/repository/categories.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/settings/google_map.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EditMyDataCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  UserCategoryList userCategories = UserCategoryList();
  CategoriesRepository _categoriesRepository = CategoriesRepository();
  UserRepository _userRepository = UserRepository();
  UserCategory userCategory = UserCategory(
    name: "Seleccionar Categoría", 
    description: "", 
    enable: true,
    collection: "",
    id: ""
  );
  late UserData userData = UserData(
    ceoName: "",
    nickname: "",
    businessName: "",
    logo: "",
    paymentUrl: "",
    userID: "",
    category: userCategory,
    address: 'Dirección default mientras hay una api key'
  );
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
        userData = arguments["data"];
      }
    }
    getUserCategories();
    getSession();
  }

  void getSession()async{
      Session sesionData = (await _userRepository.getUserSessionData())!;
      this.userData.userID = sesionData.userId;
  }


  void saveMyData(){
    _userRepository.saveMyData(data: this.userData.toJson())
    .then((value){
      if(value.id != null){
      btnController.success();
      MyGetStorage().replaceData(key: "userData", data: this.userData);
      MyAlert.showMyDialog(title: 'Datos guardados', message: 'tus datos han sido actualizados satisfactoriamente', color: Colors.green);
      Timer(Duration(seconds:3), ()=>Get.off(SplashPage(), transition: Transition.leftToRightWithFade));
      }else{
      btnController.error();
      //MyGetStorage().replaceData(key: "userData", data: this.userData);
      MyAlert.showMyDialog(title: '¡Error!', message: 'Hubo un error inesperado al guardar tus datos', color: Colors.red);
      Timer(Duration(seconds:3), ()=>btnController.reset());
      }
    });
  }

    void updateMyData()async{
      try{
    _userRepository.updateMyData(data: this.userData)
    .then((value){
      switch (value!.statusCode) {
        case 201:
          btnController.success();
          MyGetStorage().replaceData(key: "userData", data: this.userData);
          MyAlert.showMyDialog(title: 'Datos guardados', message: 'tus datos han sido actualizados satisfactoriamente', color: Colors.green);
          Timer(Duration(seconds:3), ()=>Get.off(SplashPage(), transition: Transition.leftToRightWithFade));
        break;
        default:
          btnController.error();
          MyAlert.showMyDialog(title: 'Error', message: 'hubo un problema al gardar tus datos, intenta de nuevo', color: Colors.green);
          Timer(Duration(seconds:3), ()=> btnController.reset());
          break;
      }
      });
      }catch(e){
        print('Error update: $e');
      }
  }

  void getUserCategories()async{
    try {
      _categoriesRepository.getCategories()
      .then((UserCategoryList value){
        userCategories = value;
        update();
        print(value.categories![0].description);
      });
    } catch (e) {
    print('Error get Categories]: $e');
    }
  }

    void showPicker(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: userCategories.categories!.isNotEmpty ? ListView.builder(
                    itemCount: userCategories.categories!.length,
                    itemBuilder: (ctx, index){
                      return InkWell(
                        onTap: (){
                          userData.category = userCategories.categories![index];
                          update();
                          Navigator.pop(context);
                          },
                        child: ListTile(
                          trailing: new Icon(LineIcons.plus, color: color500,),
                          title: new Text(userCategories.categories![index].name, style: subtitulo,),
                          subtitle: new Text(userCategories.categories![index].description, style: body2,),
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

  void logout(){
    try {
      //_userRepository.getSessions()
      //.then((value){
        //_session = Session.fromJson(value!.data);
          _userRepository.logout()
          .then((value) async {
            await MyGetStorage().eraseData();
            Get.off(SplashPage(), transition: Transition.cupertino);
          });
      //});
    } catch (e) {
    }
  }

  /*void getAddress({required BuildContext context})async{
  final kInitialPosition =  LatLng(-33.8567844, 151.213108);
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: GoogleMapSettings.api,
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,
  
            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              userData.address = result.adrAddress;
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
  }*/
  }
  