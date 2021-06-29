import 'dart:async';
import 'package:cotizapack/model/token_reset_password.dart';
import 'package:get/get.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RecoveryCtrl extends GetxController {
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();
  AccountRepository _accountRepository = AccountRepository();
  TokenReset tokenReset = TokenReset();
  RxInt activeStep = 0.obs;
  RxInt dotCount = 4.obs;
  String email = '', newPassword1 = '', newPassword2 = '';

  void sendEmail() async {
    _accountRepository.createPasswordRecovery(email: email).then((value) {
      if (value.id != null) {
        tokenReset = value;
        btnController.success();
        MyAlert.showMyDialog(
            title: 'Correo enviado',
            message:
                'revisa tu correo electrónico, te hemos enviado un link de reseteo',
            color: Colors.green);
        return Timer(Duration(seconds: 3), () => nextButton());
      } else {
        btnController.error();
        MyAlert.showMyDialog(
            title: 'Error al enviar correo de confirmación',
            message:
                'No se pudo encontrar el correo. Ingresa el correo de tu cuenta, o crea uno si no lo tienes',
            color: Colors.red);
        return Timer(Duration(seconds: 3), () => btnController.reset());
      }
    });
  }

  void nextButton() {
    if (activeStep.value < dotCount.value) {
      activeStep.value++;
      btnController.reset();
    }
  }

  void backButton() {
    if (activeStep.value > 0) {
      activeStep.value--;
      btnController.reset();
    } else {
      Get.back();
    }
  }

  void setRecoveryCode() async {
    _accountRepository
        .completePasswordRecovery(
            token: tokenReset, password1: newPassword1, password2: newPassword2)
        .then((value) {
      if (value.id != null) {
        btnController.success();
        MyAlert.showMyDialog(
            title: 'Contraseña actualizada',
            message:
                'el reseteo de la contraseña fué realizada satisfactoriamente',
            color: Colors.green);
        return Timer(Duration(seconds: 3), () => nextButton());
      } else {
        btnController.error();
        MyAlert.showMyDialog(
            title: 'Error al actualizar la contraseña',
            message: 'hubo un problema inesperado, intenta de nuevo',
            color: Colors.red);
        return Timer(Duration(seconds: 3), () => btnController.reset());
      }
    });
  }
}
