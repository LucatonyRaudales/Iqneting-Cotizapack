import 'dart:async';

import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../home_page.dart';

class SplashCtrl extends GetxController{
  MyGetStorage _storage = MyGetStorage();
  @override
  void onInit() {
    islogin();
    super.onInit();
  }

  void islogin()async{
    dynamic page;
    try{
      var response = await UserRepository().getSessions();
      if(response!.statusCode == 200){
        page = HomePage();
      }else{
          page = LoginPage();
      }
      Timer(Duration(seconds: 1), ()=> Get.off(page, transition: Transition.zoom));
    }catch(e){
      print('Error splash: $e');
      Timer(Duration(seconds: 2), ()=> Get.off(LoginPage(), transition: Transition.zoom));
    }
    //
  }
}