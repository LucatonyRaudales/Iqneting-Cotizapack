import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/categories.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/routes/app_pages.dart';
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

import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditMyDataCtrl extends GetxController {
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();
  UserCategoryList userCategories = UserCategoryList();
  CategoriesRepository _categoriesRepository = CategoriesRepository();
  UserRepository _userRepository = UserRepository();
  UserCategory userCategory = UserCategory(
      name: "Seleccionar Categoría",
      description: "",
      enable: true,
      collection: "",
      id: "");
  late UserData? userData = UserData(
      createAt: 0,
      ceoName: "",
      rfc: "",
      nickname: "",
      businessName: "",
      logo: "",
      paymentUrl: "",
      userID: "",
      category: userCategory,
      address: '');
  var arguments = Get.arguments;
  bool isUpdate = false;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  _init() {
    if (arguments["editData"]) {
      isUpdate = true;
      if (arguments["data"] != null) {
        userData = arguments["data"];
      }
    }
    getUserCategories();
    getSession();
  }

  void getAddress({required BuildContext context}) async {
    final kInitialPosition = LatLng(-33.8567844, 151.213108);
    Get.to(
      () => PlacePicker(
        apiKey: GoogleMapSettings.api,
        initialPosition: kInitialPosition,
        useCurrentLocation: true,

        //usePlaceDetailSearch: true,
        onPlacePicked: (result) {
          userData!.address = result.formattedAddress;
          if (result.adrAddress != null) userData!.address = result.adrAddress;

          Get.back();
          update();
        },
        selectedPlaceWidgetBuilder:
            (context, selectedPlace, state, isSearchBarFocused) {
          return isSearchBarFocused
              ? Container()
              : FloatingCard(
                  bottomPosition: MediaQuery.of(context).size.height * 0.05,
                  leftPosition: MediaQuery.of(context).size.width * 0.025,
                  rightPosition: MediaQuery.of(context).size.width * 0.025,
                  width: MediaQuery.of(context).size.width * 0.9,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 4,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          selectedPlace?.formattedAddress ?? '',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(color500)),
                          onPressed: () {
                            userData!.address = selectedPlace!.formattedAddress;
                            if (selectedPlace.adrAddress != null &&
                                !selectedPlace.adrAddress!.contains('<span'))
                              userData!.address = selectedPlace.adrAddress;

                            Get.back();
                            update();
                          },
                          child: Text("Selecionar"),
                        ),
                      ],
                    ),
                  ),
                );
        },
        forceSearchOnZoomChanged: true,
        automaticallyImplyAppBarLeading: true,
        autocompleteLanguage: "es",
        region: 'mx',
        selectInitialPosition: true,
      ),
      fullscreenDialog: true,
      popGesture: true,
    );
  }

  void getSession() async {
    Session sesionData = (await _userRepository.getUserSessionData())!;
    this.userData!.userID = sesionData.userId;
  }

  Future<bool> validateNickName() async {
    return true;
  }

  void saveMyData() async {
    this.userData!.createAt = DateTime.now().microsecondsSinceEpoch;
    this.userData!.enable = true;
    if (await _userRepository.validateNickName(
        nickName: this.userData!.nickname!)) {
      Timer(Duration(seconds: 3), () => btnController.reset());
      return MyAlert.showMyDialog(
          title: 'Error',
          message: 'Ya existe un usuario con ese alias.',
          color: Colors.red);
    }

    _userRepository.saveMyData(data: this.userData!.toJson()).then((value) {
      if (value.id != null) {
        btnController.success();
        MyGetStorage().replaceData(key: "userData", data: value.toJson());
        MyAlert.showMyDialog(
            title: 'Datos guardados',
            message: 'tus datos han sido actualizados satisfactoriamente',
            color: Colors.green);
        Timer(Duration(seconds: 3), () => Get.offAllNamed(Routes.INITIAL));
      } else {
        btnController.error();
        //MyGetStorage().replaceData(key: "userData", data: this.userData);
        MyAlert.showMyDialog(
            title: '¡Error!',
            message: 'Hubo un error inesperado al guardar tus datos',
            color: Colors.red);
        Timer(Duration(seconds: 3), () => btnController.reset());
      }
    });
  }

  void updateMyData() async {
    try {
      _userRepository.updateMyData(data: this.userData!).then((value) {
        if (value == null) {
          btnController.error();
          MyAlert.showMyDialog(
              title: 'Error',
              message: 'hubo un problema al gardar tus datos, intenta de nuevo',
              color: Colors.red);
          Timer(Duration(seconds: 3), () => btnController.reset());
          return;
        }

        if (value.statusCode! >= 200 && value.statusCode! <= 299) {
          btnController.success();
          MyGetStorage()
              .replaceData(key: "userData", data: this.userData!.toJson());
          MyAlert.showMyDialog(
              title: 'Datos guardados',
              message: 'tus datos han sido actualizados satisfactoriamente',
              color: Colors.green);
          Timer(Duration(seconds: 3), () => Get.offAllNamed(Routes.INITIAL));
        }
      });
    } catch (e) {
      print('Error update: $e');
    }
  }

  void getUserCategories() async {
    try {
      _categoriesRepository.getCategories().then((UserCategoryList value) {
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
              child: userCategories.categories!.isNotEmpty
                  ? ListView.builder(
                      itemCount: userCategories.categories!.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            userData!.category =
                                userCategories.categories![index];
                            update();
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            trailing: new Icon(
                              LineIcons.plus,
                              color: color500,
                            ),
                            title: new Text(
                              userCategories.categories![index].name,
                              style: subtitulo,
                            ),
                            subtitle: new Text(
                              userCategories.categories![index].description,
                              style: body2,
                            ),
                          ),
                        );
                      })
                  : new Center(child: new Text('Cargando')),
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

  void logout() {
    try {
      //_userRepository.getSessions()
      //.then((value){
      //_session = Session.fromJson(value!.data);
      _userRepository.logout().then((value) async {
        await MyGetStorage().eraseData();
        Get.offNamed(Routes.INITIAL);
      });
      //});
    } catch (e) {}
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
