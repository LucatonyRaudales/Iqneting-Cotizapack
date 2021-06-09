import 'dart:typed_data';

import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/PakageModel.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'My_pakage_control.dart';

class MyPakagePage extends GetResponsiveView<ListPakageController> {
  @override
  Widget builder() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Paquetes'),
        backgroundColor: color500,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.obx(
                  (data) => GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: data!.map((e) => myCard(e)).toList(),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color500,
        onPressed: () => Get.toNamed(Routes.SHOPPACKAGE),
        child: Icon(Icons.attach_money_rounded),
      ),
    );
  }

  Container widgetImage(Pakageclass data) {
    return Container(
      width: (Get.width / 2) - 4,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color300,
        borderRadius: BorderRadius.circular(10),
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
                    ? Icon(LineIcons.exclamationCircle, color: Colors.red)
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
    );
  }

  Widget myCard(Pakageclass? data) {
    if (data == null)
      return Container(
        child: Text('No Data'),
      );
    return InkWell(
      onTap: () => showpackageDetail(Get.context!, data, controller.image!),
      child: Container(
        padding: EdgeInsets.all(1),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                  child: widgetImage(data),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: (Get.width / 2) - 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          data.description,
                          style: subtitulo,
                        ),
                        Text(
                          data.description,
                          style: body1,
                        ),
                        Text(
                          'Cotizaciones: ${data.quotations} unds',
                          style: body1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  void showpackageDetail(
      BuildContext context, Pakageclass data, Uint8List image) {
    MyBottomSheet().show(
      context,
      Get.height / 1.09,
      ListView(
        children: <Widget>[
          Hero(
            tag: 'widget.id.toString()',
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: Get.width,
              height: 290,
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
          Padding(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(LineIcons.moneyBill, color: color500),
                  title: new Text(data.price.toString(), style: body1),
                  subtitle: new Text('Precio', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.fileInvoice, color: color500),
                  title: new Text(data.quotations.toString(), style: body1),
                  subtitle: new Text('Cotizaciones', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.calendarAlt, color: color500),
                  title: new Text(
                      '${DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(data.updatedAt))}',
                      style: body1),
                  subtitle: new Text('Adquirido', style: body2),
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
}
