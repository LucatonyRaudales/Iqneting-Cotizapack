import 'package:conekta_flutter/conekta_card.dart';
import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/creditcard_model.dart';
import 'package:cotizapack/routes/app_pages.dart';
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

    if (MyGetStorage().haveData(key: 'tokencreditCard')) {
      var data = MyGetStorage().readData(key: 'creditCard');
      creditcard = CreditCardModelLocal.fromMap(data!);
      cardNumber = creditcard.cardNumber;
      expiryDate = creditcard.expiryDate;
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

  savecard() async {
    var creditcard = CreditCardModelLocal(
      cardHolderName: cardHolderName,
      cardNumber: cardNumber,
      cvvCode: cvvCode,
      expiryDate: expiryDate,
    );
    try {
      final conektaCard = ConektaCard(
        cardName: creditcard.cardHolderName,
        cardNumber: creditcard.cardNumber,
        cvv: creditcard.cvvCode,
        expirationMonth: creditcard.expiryDate.split("/")[0],
        expirationYear: creditcard.expiryDate.split("/")[1],
      );
      final String token = await conektaFlutter.createCardToken(conektaCard);
      await MyGetStorage()
          .saveData(key: 'creditCard', data: creditcard.toMap());

      await MyGetStorage().saveData(key: 'tokencreditCard', data: token);
      print(token);
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
          await MyGetStorage().box.remove('tokencreditCard');
          await MyGetStorage().box.remove('creditCard');
          Get.back();
          Get.back();
        });
  }
}
