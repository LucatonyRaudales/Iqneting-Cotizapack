import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/user_model.dart';
import 'package:cotizapack/pages/login/login_page.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpCtrl extends GetxController {
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();
  UserRepository _userRepository = UserRepository();
  UserModel user = UserModel();
  RxBool viewPass = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void signup() async {
    _userRepository.signup(user: user).then((value) {
      switch (value?.statusCode) {
        case 201:
          btnController.success();
          MyAlert.showMyDialog(
              title: 'Te has registrado correctamente!',
              message: 'inicia sesión para configurar tu perfíl',
              color: Colors.green);
          Timer(Duration(seconds: 2), () {
            Get.offAll(LoginPage(), transition: Transition.zoom);
          });
          break;
        default:
          print('asaber');
      }
    }).catchError((e) {
      var error = e as AppwriteException;
      if (error.code == 409) {
        btnController.error();
        MyAlert.showMyDialog(
            title: 'Error',
            message: 'El correo ya esta registrado. por favor utilizar otro',
            color: Colors.red);
        Timer(Duration(seconds: 3), () {
          btnController.reset();
        });
        return;
      }
      btnController.error();
      MyAlert.showMyDialog(
          title: 'Error inesperado',
          message: 'desconocemos el motivo. Por favor, intenta de nuevo',
          color: Colors.red);
      Timer(Duration(seconds: 3), () {
        btnController.reset();
      });
    });
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
