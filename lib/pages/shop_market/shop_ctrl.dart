import 'dart:async';
import 'dart:typed_data';

import 'package:conekta_flutter/conekta_card.dart';
import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:cotizapack/common/Collections_api.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/model/MyPackage.dart';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/model/creditcard_model.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/repository/ProcessPay_Service.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/repository/mypackage_repository.dart';
import 'package:cotizapack/repository/packageRepository.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';

class ShopQuotationsCtrl extends GetxController
    with StateMixin<List<Pakageclass>?> {
  Pakageclass? pakageclass;
  Uint8List? image;
  RxInt opcion = 0.obs;
  var creditcard = CreditCardModelLocal();
  final conektaFlutter = ConektaFlutter();
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    conektaFlutter.setApiKey(Collections.CONEKTAAPI);
    getPakage();
    super.onInit();
  }

  getPakage() {
    try {
      change(null, status: RxStatus.loading());
      PackaRepository().getPackages().then((value) {
        if (value == null)
          change(null, status: RxStatus.error('A Ocurrido un error'));
        if (value?.length == 0) change(null, status: RxStatus.empty());
        if (MyGetStorage().haveData(key: 'creditCard')) {
          var card = MyGetStorage().readData(key: 'creditCard');
          creditcard = CreditCardModelLocal.fromMap(card!);
        }
        change(value, status: RxStatus.success());
      }).timeout(Duration(seconds: 3), onTimeout: () {
        change(
          null,
          status: RxStatus.error(
            'error: ¡Se a Tardado Demaciado!',
          ),
        );
      });
    } catch (e) {
      change(
        null,
        status: RxStatus.error(
          'error: $e',
        ),
      );
    }
  }

  payPakage(Pakageclass data) {
    try {
      var cvvconfirm = '';
      Get.defaultDialog(
          title: "Codigo de confirmacion",
          content: Container(
            child: InputText(
              name: 'CVV',
              validator: Validators.urlValidator,
              autofillHints: [AutofillHints.addressCity],
              textInputType: TextInputType.number,
              obscureText: true,
              maxLines: 1,
              prefixIcon: Icon(LineIcons.creditCard),
              onChanged: (val) {
                cvvconfirm = val.trim();
              },
            ),
          ),
          textCancel: 'Cancelar',
          textConfirm: "Confirmar",
          confirmTextColor: Colors.white,
          cancelTextColor: color700,
          buttonColor: color700,
          titleStyle: TextStyle(color: color700),
          onConfirm: () async {
            if (cvvconfirm == creditcard.cvvCode) {
              Get.back();
              MyAlert.showMyDialog(
                  title: 'Tarjeta',
                  message: 'Confirmada Procesando su compra',
                  color: Colors.green);
              processbuy(data);
            } else {
              MyAlert.showMyDialog(
                title: 'Tarjeta',
                message: 'Codigo incorrecto',
                color: Colors.red,
              );
            }
          });
    } catch (e) {
      printError(info: e.toString());
    } finally {}
  }

  processbuy(Pakageclass data) async {
    try {
      final conektaCard = ConektaCard(
        cardName: creditcard.cardHolderName,
        cardNumber: creditcard.cardNumber,
        cvv: creditcard.cvvCode,
        expirationMonth: creditcard.expiryDate.split("/")[0],
        expirationYear: creditcard.expiryDate.split("/")[1],
      );
      final String token = await conektaFlutter.createCardToken(conektaCard);

      BuyProvider buyProvider = BuyProvider();
      var user = await MyGetStorage().listenUserData();
      var datauser = await readUserData();
      var resutl = await buyProvider.buyPackage(
          name: user.ceoName!,
          phone: user.phone!,
          email: datauser.email!,
          itemName: data.name,
          unitprice: data.price * 100,
          quantity: 1,
          tokenID: "$token");
      if (resutl == null)
        return MyAlert.showMyDialog(
          title: 'Pago',
          message: 'Pago no realizado',
          color: Colors.red,
        );
      if (resutl.statusCode! >= 400) {
        Get.back();
        return MyAlert.showMyDialog(
          title: 'Pago',
          message: 'Pago no realizado',
          color: Colors.red,
        );
      }
      if (resutl.statusCode == 201) {
        var res = await MyPackaRepository()
            .saveMyPackage(mypackage: Mypackage(package: data))
            .onError((error, stackTrace) {
          printError(info: error.toString());
        });
        if (res == null) return;

        if (res.statusCode! > 400) return;

        if (res.statusCode! >= 200 && res.statusCode! < 300) {
          3.delay(() => Get.offAllNamed(Routes.INITIAL));
          MyAlert.showMyDialog(
              title: 'Exito',
              message: 'Su compra se realizo con éxito',
              color: Colors.green);
        }
      }
    } catch (e) {}
  }

  Future<MyAccount> readUserData() async {
    MyAccount myAccount;
    if (MyGetStorage().haveData(key: 'accountData')) {
      myAccount =
          MyAccount.fromJson(MyGetStorage().readData(key: 'accountData')!);
    } else {
      myAccount = (await AccountRepository().getAccount())!;
    }
    print('ID del usuario ${myAccount.id}');
    return myAccount;
  }
}
