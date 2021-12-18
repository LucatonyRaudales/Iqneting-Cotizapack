import 'package:conekta_flutter/conekta_card.dart';
import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/creditcard_model.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/encript.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreditcardController extends GetxController
    with SingleGetTickerProviderMixin {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  CreditCardModelLocal creditcard = CreditCardModelLocal();
  final conektaFlutter = ConektaFlutter();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();
  @override
  void onInit() {
    // conektaFlutter.setApiKey('key_AsSsrC4am4q8qp3zdTsqyHg');
    conektaFlutter.setApiKey(Collections.CONEKTAAPI);

    if (MyGetStorage().haveData(key: 'creditCard')) {
      var data = MyGetStorage().readData(key: 'creditCard');
      creditcard = CreditCardModelLocal.fromMap(data!);
      cardNumber = Encript().desencription(creditcard.cardNumber);
      expiryDate = Encript().desencription(creditcard.expiryDate);
      cardHolderName = creditcard.cardHolderName;
    }
    super.onInit();
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber = creditCardModel!.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    update();
  }

  confirmar() {
    Get.defaultDialog(
        title: "¡Advertencia!",
        textCancel: 'Cancelar',
        textConfirm: "Confirmar",
        middleText:
            "Los datos de la tarjeta se guardarán bajo un estricto sistema de encriptación",
        middleTextStyle: TextStyle(color: color700),
        confirmTextColor: Colors.white,
        cancelTextColor: color700,
        buttonColor: color700,
        titleStyle: TextStyle(color: color700),
        onCancel: () {
          2.delay(() => roundedLoadingButtonController.reset());
        },
        onWillPop: () {
          Get.back();
          2.delay(() => roundedLoadingButtonController.reset());
          return Future.value(true);
        },
        onConfirm: () async {
          Get.back();
          savecard();
        });
  }

  savecard() async {
    var creditcard = CreditCardModelLocal(
      cardHolderName: cardHolderName,
      cardNumber: Encript().encription(cardNumber),
      cvvCode: Encript().encription(cvvCode),
      expiryDate: Encript().encription(expiryDate),
    );
    try {
      final conektaCard = ConektaCard(
        cardName: creditcard.cardHolderName,
        cardNumber: Encript().desencription(creditcard.cardNumber),
        cvv: Encript().desencription(creditcard.cvvCode),
        expirationMonth:
            Encript().desencription(creditcard.expiryDate).split("/")[0],
        expirationYear:
            Encript().desencription(creditcard.expiryDate).split("/")[1],
      );
      await conektaFlutter.createCardToken(conektaCard);
      await MyGetStorage()
          .saveData(key: 'creditCard', data: creditcard.toMap());
      MyAlert.showMyDialog(
        title: '¡Exito!',
        message: 'Datos guardados de forma segura.',
        color: Colors.green,
      );
      roundedLoadingButtonController.success();
      3.delay(() => Get.offAllNamed(Routes.INITIAL));
    } on PlatformException catch (e) {
      roundedLoadingButtonController.error();
      if (e.message.toString() == 'The card number is invalid.') {
        return MyAlert.showMyDialog(
          title: 'Error',
          message: 'tarjeta no valida',
          color: Colors.red,
        );
      }
      MyAlert.showMyDialog(
        title: 'Error',
        message: 'Su tarjeta no fue guardada correctamente',
        color: Colors.red,
      );
    } finally {
      2.delay(() => roundedLoadingButtonController.reset());
    }
  }

  deletecard() {
    Get.defaultDialog(
        title: "¡Advertencia!",
        content: Column(
          children: [
            Text(
              "Se Eliminar la tarjeta ",
              maxLines: 2,
            ),
            Text("¿Esta Seguro?"),
          ],
        ),
        textCancel: 'Cancelar',
        textConfirm: "Confirmar",
        confirmTextColor: Colors.white,
        cancelTextColor: color700,
        buttonColor: color700,
        titleStyle: TextStyle(color: color700),
        onConfirm: () async {
          await MyGetStorage().box.remove('creditCard');
          Get.back();
          Get.back();
        });
  }
}
