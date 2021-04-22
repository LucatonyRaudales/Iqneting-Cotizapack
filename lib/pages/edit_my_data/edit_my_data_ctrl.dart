import 'dart:async';

import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/categories.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../home_page.dart';

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
    giro: "",
    userID: "",
    category: userCategory
  ) ;
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
      btnController.success();
      MyAlert.showMyDialog(title: 'Datos guardados', message: 'tus datos han sido guardados satisfactoriamente', color: Colors.green);
      Timer(Duration(seconds:3), ()=>Get.off(HomePage(), transition: Transition.leftToRightWithFade));
    });
  }

    void updateMyData()async{
      try{
    _userRepository.updateMyData(data: this.userData)
    .then((value){
      btnController.success();
      MyGetStorage().replaceData(key: "userData", data: this.userData);
      MyAlert.showMyDialog(title: 'Datos guardados', message: 'tus datos han sido actualizados satisfactoriamente', color: Colors.green);
      Timer(Duration(seconds:3), ()=>Get.off(HomePage(), transition: Transition.leftToRightWithFade));
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
    /*showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              width: Get.width,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  userCategories.categories!.isNotEmpty ?
                  ListView.builder(
                    itemCount: 2,
                    itemBuilder: (ctx, index){
                      return new Text(userCategories.categories![0].name, style: subtitulo,);
                    })
                    : new Center(
                      child: new Text('Cargando')
                    )
                ],
                onSelectedItemChanged: (value) {
                  print('categoría seleccionado: $value');
                },
              ),
            ));*/
  }
}