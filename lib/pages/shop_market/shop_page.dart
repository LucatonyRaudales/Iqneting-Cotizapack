import 'dart:math';
import 'dart:typed_data';

import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/pages/shop_market/shop_ctrl.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/settings/encript.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class ShopQuotationsPage extends GetResponsiveView<ShopQuotationsCtrl> {
  @override
  Widget builder() {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: color500,
        centerTitle: true,
        title: Text(
          'Comprar un paquete',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff6f7f9),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.obx(
                (state) => GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: state!.map((e) => myCard(e)).toList(),
                ),
                onEmpty: emptyData(),
                onLoading: Center(
                  child: SpinKitPulse(
                    color: color500,
                    size: 50.0,
                  ),
                ),
                onError: (error) {
                  return emptyData();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container emptyData() {
    return Container(
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Icon(LineIcons.hushedFace, size: 50, color: color500),
            SizedBox(
              height: 20,
            ),
            Text(
              'No hay paquetes para mostrar',
              style: subtitulo,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            TextButton(
              child: Text(
                "Intentar de nuevo?",
                style: body1,
              ),
              onPressed: () => null,
            ),
          ],
        ),
      ),
    );
  }

  Widget myCard(Pakageclass? data) {
    if (data == null)
      return Container(
        child: Text('No Data'),
      );
    return InkWell(
      onTap: () => showpackageDetail(Get.context!, data),
      child: Container(
        padding: EdgeInsets.all(1),
        child: Stack(
          children: [
            Card(
              color: null,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "${data.name}".toUpperCase(),
                        style: TextStyle(
                            color: color500,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: color400,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            text: '\$' +
                                (data.onSale
                                    ? (data.price /
                                                ((data.percentage / 100) + 1))
                                            .toStringAsFixed(2) +
                                        " /"
                                    : "${data.price.toStringAsFixed(2)}"),
                            children: [
                              if (data.onSale)
                                TextSpan(
                                  text: '${data.price.toStringAsFixed(2)} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    decorationStyle: TextDecorationStyle.wavy,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.opcion.value = 0;
                              showBuyPackage(Get.context!, data);
                            },
                            child: Text(
                              'Comprar',
                              style: TextStyle(color: color100),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(color500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (data.onSale)
              Positioned(
                bottom: 5,
                right: -60,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateZ(-pi / 4),
                  child: Transform.translate(
                    offset: Offset(-42, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade900,
                            Colors.red.shade900,
                            Colors.red,
                            Colors.red,
                            Colors.red.shade900,
                            Colors.red.shade900,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: color300,
                          ),
                        ],
                        color: Colors.red,
                      ),
                      height: 30,
                      width: 120,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Oferta ${data.percentage}%',
                            style: TextStyle(
                              color: color100,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                    blurRadius: 2,
                                    color: Colors.white.withOpacity(0.2))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void showpackageDetail(BuildContext context, Pakageclass data) {
    MyBottomSheet().show(
      context,
      Get.height / 1.09,
      ListView(
        children: <Widget>[
          Hero(
            tag: 'widget.id.toString()',
            child: Container(
              width: Get.width,
              height: 290,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                ),
              ),
              child: data.image == ''
                  ? Center(child: Icon(LineIcons.plus))
                  : FutureBuilder<Uint8List?>(
                      future: MyStorage().getFilePreview(
                        fileId: data.image,
                      ), //works for both public file and private file, for private files you need to be logged in
                      builder: (context, data) {
                        controller.image = data.data;
                        return data.hasError
                            ? Icon(LineIcons.exclamationCircle,
                                color: Colors.red)
                            : data.hasData && data.data != null
                                ? Image.memory(
                                    data.data!,
                                    fit: BoxFit.fill,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                      },
                    ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 90,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(data.name, style: subtitulo),
                        SizedBox(
                          height: 10,
                        ),
                        new Text(data.description, style: body1),
                      ],
                    ),
                  ),
                ),
              ),
              if (data.onSale) bannerOnSale(data)
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(LineIcons.moneyBill, color: color500),
                  title: new RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      text: '\$' +
                          (data.onSale
                              ? (data.price / ((data.percentage / 100) + 1))
                                      .toStringAsFixed(2) +
                                  " /"
                              : "${data.price.toStringAsFixed(2)}"),
                      children: [
                        if (data.onSale)
                          TextSpan(
                            text: '${data.price.toStringAsFixed(2)} ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.wavy,
                              decorationColor: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  subtitle: new Text('Precio', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.fileInvoice, color: color500),
                  title: new Text(data.quotations.toString(), style: body1),
                  subtitle: new Text('Cotizaciones', style: body2),
                ),
                if (data.onSale)
                  ListTile(
                    leading: Icon(LineIcons.calendarAlt, color: color500),
                    title: new Text(
                        '${DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(data.expirationPromo))}',
                        style: body1),
                    subtitle:
                        new Text('Finalizacion de la promocion', style: body2),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: color500,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Atrás",
                    style: subtituloblanco,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showBuyPackage(BuildContext context, Pakageclass data) {
    MyBottomSheet()
        .show(context, Get.height / 1.9, Obx(() => opcionsbuy(data)));
  }

  opcionsbuy(Pakageclass data) {
    switch (controller.opcion.value) {
      case 0:
        return opcionone(data);
      case 1:
        return opciontwo(data);

      default:
    }
  }

  Positioned bannerOnSale(Pakageclass data) {
    return Positioned(
      top: -5,
      right: -110,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(pi / 4),
        child: Transform.translate(
          offset: Offset(-42, 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade900,
                  Colors.red.shade900,
                  Colors.red,
                  Colors.red,
                  Colors.red.shade900,
                  Colors.red.shade900,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: color300,
                ),
              ],
              color: Colors.red,
            ),
            height: 30,
            width: 140,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Oferta ${data.percentage}%',
                  style: TextStyle(
                    color: color100,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                          blurRadius: 2, color: Colors.white.withOpacity(0.2))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  opcionone(Pakageclass data) {
    return ListView(
      children: <Widget>[
        Stack(
          children: [
            Container(
              height: 90,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(data.name, style: subtitulo),
                      SizedBox(
                        height: 10,
                      ),
                      new Text(data.description, style: body1),
                    ],
                  ),
                ),
              ),
            ),
            if (data.onSale) bannerOnSale(data)
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(LineIcons.moneyBill, color: color500),
                title: new RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    text: '\$' +
                        (data.onSale
                            ? (data.price / ((data.percentage / 100) + 1))
                                    .toStringAsFixed(2) +
                                " /"
                            : "${data.price.toStringAsFixed(2)}"),
                    children: [
                      if (data.onSale)
                        TextSpan(
                          text: '${data.price.toStringAsFixed(2)} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                subtitle: new Text('Precio', style: body2),
              ),
              ListTile(
                leading: Icon(LineIcons.fileInvoice, color: color500),
                title: new Text(data.quotations.toString(), style: body1),
                subtitle: new Text('Cotizaciones', style: body2),
              ),
              if (data.onSale)
                ListTile(
                  leading: Icon(LineIcons.calendarAlt, color: color500),
                  title: new Text(
                      '${DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(data.expirationPromo))}',
                      style: body1),
                  subtitle:
                      new Text('Finalizacion de la promocion', style: body2),
                ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            controller.opcion.value = 1;
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: color500,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Comprar",
                  style: subtituloblanco,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  opciontwo(Pakageclass data) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.creditcard.cardNumber.length == 0
                  ? ListTile(
                      leading: Icon(LineIcons.creditCard, color: color500),
                      title: new Text('No hay una tarjeta registrada',
                          style: body1),
                      subtitle: new Text('', style: body2),
                    )
                  : ListTile(
                      leading: Icon(LineIcons.creditCard, color: color500),
                      title: new Text(
                          Encript()
                              .desencription(controller.creditcard.cardNumber)
                              .replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*'),
                          style: body1),
                      subtitle: new Text(
                          Encript()
                              .desencription(controller.creditcard.expiryDate),
                          style: body2),
                    ),
              ListTile(
                leading: Icon(LineIcons.moneyBill, color: color500),
                title: new RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    text: '\$' +
                        (data.onSale
                            ? (data.price / ((data.percentage / 100) + 1))
                                    .toStringAsFixed(2) +
                                " /"
                            : "${data.price.toStringAsFixed(2)}"),
                    children: [
                      if (data.onSale)
                        TextSpan(
                          text: '${data.price.toStringAsFixed(2)} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                subtitle: new Text('Precio', style: body2),
              ),
              ListTile(
                leading: Icon(LineIcons.fileInvoice, color: color500),
                title: new Text(data.quotations.toString(), style: body1),
                subtitle: new Text('Cotizaciones', style: body2),
              ),
              if (data.onSale)
                ListTile(
                  leading: Icon(LineIcons.calendarAlt, color: color500),
                  title: new Text(
                      '${DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(data.expirationPromo))}',
                      style: body1),
                  subtitle:
                      new Text('Finalizacion de la promocion', style: body2),
                ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            if (controller.creditcard.cardNumber.length == 0)
              return MyAlert.showMyDialog(
                title: 'Tarjeta',
                message: 'No cuenta con una tarjeta registrada',
                color: Colors.red,
              );
            controller.payPakage(data);
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: color500,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Pagar",
                  style: subtituloblanco,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
