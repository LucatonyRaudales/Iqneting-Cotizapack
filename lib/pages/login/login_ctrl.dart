import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/get_storage.dart';
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
  RxBool viewPass = true.obs;

  void signIn() async {
    try {
      _userRepository.signIn(user: user).then((value) async {
        MyGetStorage().eraseData();
        var a = MyGetStorage().readData(key: 'userData');
        print(a);
        switch (value?.statusCode) {
          case 201:
            btnController.success();
            MyAlert.showMyDialog(
                title: '¡Bienvenid@!',
                message: 'estamos cargando tus datos',
                color: Colors.green);
            Timer(Duration(seconds: 2), () => Get.offAllNamed(Routes.INITIAL));
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

  void loginWithGoogle() async {
    try {
      await SocialAuth().googleSignIn();
      Get.offAllNamed(Routes.INITIAL);
    } on AppwriteException catch (e) {
      print('Error $e');
      return MyAlert.showMyDialog(
        title: 'Google Error',
        message: 'hubo un problema al obtener los datos de Google',
        color: Colors.red,
      );
    }
    Timer(Duration(seconds: 2), () {});
  }

  void loginWithFacebook() async {
    try {
      await SocialAuth().facebookSignIn();
      Get.offAllNamed(Routes.INITIAL);
    } on AppwriteException catch (e) {
      print('Error $e');
      return MyAlert.showMyDialog(
        title: 'Google Error',
        message: 'hubo un problema al obtener los datos de Facebook',
        color: Colors.blue,
      );
    }
    Timer(Duration(seconds: 2), () {});
  }
}
