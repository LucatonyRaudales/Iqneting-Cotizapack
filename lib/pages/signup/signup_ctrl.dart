import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/social_auth_models.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpCtrl extends GetxController{
  final RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  UserRepository _userRepository = UserRepository();
  UserModel user = UserModel();

  @override
  void onInit() {  
    super.onInit();
  }

  void signup()async{
    try{
      _userRepository.signup(user: user)
      .then((value){
        switch(value?.statusCode){
          case 201:
            btnController.success();
            MyAlert.showMyDialog(title: 'Te has registrado correctamente!', message: 'inicia sesión para configurar tu perfíl', color: Colors.green);
            Timer(Duration(seconds: 2), (){
              Get.offAll(LoginPage(), transition: Transition.zoom);
            });
          break;
          case 500:
            btnController.error();
            MyAlert.showMyDialog(title: 'Error', message: 'por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
                btnController.reset();
            });
          break;
          default:
          btnController.error();
          MyAlert.showMyDialog(title: 'Error inesperado', message: 'desconocemos el motivo. Por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
                btnController.reset();
            });
            print('asaber');
        }
      });
    }catch(e){
      print('Error $e');
    }
  }

    
    void signUPWithFacebook()async{
    try{
      FacebookData? data = await SocialAuth().facebookLogin();
      if(data == null) return MyAlert.showMyDialog(title: 'Facebook Error', message: 'hubo un problema al obtener los datos de facebook', color: Colors.blue);
      user.email = data.email;
      user.password = data.id.toString();
      user.nickname = data.name;
      signup();
    }catch(e){
      print('Error $e');
    }
    Timer(Duration(seconds:2), (){
      
    });
  }
}