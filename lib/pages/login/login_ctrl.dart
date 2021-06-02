import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/social_auth_models.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/pages/splash/splash_screen.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginCtrl extends GetxController {
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();
  UserRepository _userRepository = UserRepository();
  UserModel user = UserModel();
  RxBool viewPass = false.obs;

  void signIn() async {
    try {
      _userRepository.signIn(user: user).then((value) async {
        switch (value?.statusCode) {
          case 201:
            btnController.success();
            MyAlert.showMyDialog(
                title: '¡Bienvenid@!',
                message: 'estamos cargando tus datos',
                color: Colors.green);
            Timer(
                Duration(seconds: 2),
                () => Get.offAll(()=>SplashPage(),
                    transition: Transition.rightToLeftWithFade));
            break;
          case 500:
            btnController.error();
            MyAlert.showMyDialog(
                title: 'Error',
                message: 'por favor, intenta de nuevo',
                color: Colors.red);
            Timer(Duration(seconds: 3), () {
              btnController.reset();
            });
            break;
          default:
            btnController.error();
            MyAlert.showMyDialog(
                title: 'Credenciales incorrectas',
                message:
                    'por favor, revisa las credenciales ingresadas o crea un nuevo perfíl',
                color: Colors.red);
            Timer(Duration(seconds: 3), () {
              btnController.reset();
            });
            print('asaber');
        }
      });
    } catch (e) {
      print('Error $e');
    }
    Timer(Duration(seconds: 2), () {});
  }

  void loginWithFacebook() async {
    try {
      FacebookData? data = await SocialAuth().facebookLogin();
      if (data == null)
        return MyAlert.showMyDialog(
            title: 'Facebook Error',
            message: 'hubo un problema al obtener los datos de facebook',
            color: Colors.blue);
      user.email = data.email;
      user.password = data.id.toString();
      signIn();
      /*_userRepository.signIn(user: user)
      .then((value)async{
        switch(value?.statusCode){
          case 201:
            MyAlert.showMyDialog(title: '¡Bienvenid@!', message: 'estamos cargando tus datos', color: Colors.green);
            Timer(Duration(seconds:2), ()=> Get.offAll(SplashPage(), transition: Transition.rightToLeftWithFade));
          break;
          case 500:
            MyAlert.showMyDialog(title: 'Error', message: 'por favor, intenta de nuevo', color: Colors.red);
            Timer(Duration(seconds: 3), (){
            });
          break;
          default:
          MyAlert.showMyDialog(title: 'Credenciales incorrectas', message: 'por favor, revisa las credenciales ingresadas o crea un nuevo perfíl', color: Colors.red);
            print('asaber');
        }
      });*/
    } catch (e) {
      print('Error $e');
    }
    Timer(Duration(seconds: 2), () {});
  }
}
