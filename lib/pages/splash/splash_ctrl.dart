import 'dart:async';

import 'package:cotizapack/model/session_model.dart';
import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../home_page.dart';

class SplashCtrl extends GetxController{
  UserRepository _userRepository = UserRepository();
  Session _session = Session();
  
  @override
  void onInit() {
    islogin();
    super.onInit();
  }

  void islogin()async{
    dynamic page;
    try{
      var response = await _userRepository.getSessions();
      if(response!.statusCode == 200){
        _session = Session.fromJson(response.data);
        bool checked = await checkuserData(session: _session);
        page = checked ? HomePage() : LoginPage();
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


  Future<bool> checkuserData({required Session session})async{
    try{
      if(MyGetStorage().haveData(key: 'userData')){
        return true;
      }{
        _userRepository.chargeUserData(userID: session.userId!)
          .then((value)async{
            await MyGetStorage().saveData(key: 'userData', data: value);
            print('Awevo, se guardaron los datos bien');
          });
          return true;
      }
    }catch(e){
      print('Error: $e');
      return false;
    }
  }
}