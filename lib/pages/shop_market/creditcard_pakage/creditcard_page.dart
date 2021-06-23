import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import 'creditcard_ctrl.dart';

class CreditcardPage extends GetView<CreditcardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tarjeta'),
            if (controller.creditcard.cardNumber.length > 0)
              IconButton(
                onPressed: controller.deletecard,
                icon: Icon(
                  Icons.delete,
                ),
              )
          ],
        ),
        backgroundColor: color500,
      ),
      body: GetBuilder<CreditcardController>(
        builder: (_) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CreditCardWidget(
                    cardNumber: controller.cardNumber,
                    expiryDate: controller.expiryDate,
                    cardHolderName: controller.cardHolderName,
                    cvvCode: controller.cvvCode,
                    showBackView: controller.isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    cardBgColor: color500,
                    labelCardHolder: "Nombre En la Tarjeta",
                    labelExpiredDate: 'Mes/Año',
                  ),
                  CreditCardForm(
                    formKey: controller.formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: controller.cardNumber,
                    cvvCode: controller.cvvCode,
                    cardHolderName: controller.cardHolderName,
                    expiryDate: controller.expiryDate,
                    themeColor: Colors.blue,
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Numero',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha vencimiento',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre En la tarjeta',
                    ),
                    onCreditCardModelChange: controller.onCreditCardModelChange,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Button(
                    name: 'Guardar',
                    btnController: controller.roundedLoadingButtonController,
                    function: () {
                      if (controller.formKey.currentState!.validate()) {
                        print('valid!');
                        controller.savecard();
                        controller.roundedLoadingButtonController.success();
                      } else {
                        print('invalid!');
                        controller.roundedLoadingButtonController.error();
                        3.delay(() {
                          controller.roundedLoadingButtonController.reset();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
