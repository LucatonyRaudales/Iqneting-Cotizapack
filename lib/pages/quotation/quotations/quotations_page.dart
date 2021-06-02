import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/ModelPDF.dart';
import 'package:cotizapack/pages/quotation/quotations/quotations_ctrl.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/generate_pdf.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class QuotationsPage extends GetView<QuotationsCtrl> {
  void showProductDetail(BuildContext context, QuotationModel quotation,
      QuotationsCtrl ctrl, int index) {
    MyBottomSheet().show(
      context,
      Get.height / 1.7,
      ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(quotation.title!, style: subtitulo),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(quotation.description!, style: body1),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: produsts(quotation: quotation),
            ),
          ),
          Divider(color: color700),
          Text(
            'gestionar cotización',
            style: subtitulo,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          quotation.status != 0
              ? new Text(
                  quotation.status == 1
                      ? 'La cotización fué aceptada'
                      : 'La cotización fué rechazada',
                  style: TextStyle(
                      color: quotation.status == 1 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w300,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                )
              : new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                        onPressed: () => ctrl.changeQuotationStatus(
                            status: "quotesCanceled",
                            quotation: quotation,
                            index: index),
                        icon: Icon(LineIcons.thumbsDown,
                            size: 20, color: Colors.redAccent),
                        label: Text('Rechazado', style: body1)),
                    TextButton.icon(
                        onPressed: () => ctrl.changeQuotationStatus(
                            status: "quotesSent",
                            quotation: quotation,
                            index: index),
                        icon: Icon(LineIcons.check,
                            size: 20, color: Colors.greenAccent),
                        label: Text('Aceptado', style: body1)),
                    TextButton.icon(
                      onPressed: () =>
                          ctrl.shareQuotation(quotation: quotation),
                      icon: Icon(LineIcons.share,
                          size: 20, color: Colors.blueAccent),
                      label: Text(
                        'compartir',
                        style: body1,
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 15,
          ),
          Divider(color: color700),
          SizedBox(
            height: 15,
          ),
          TextButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, size: 20, color: color500),
              label: Text('Atrás', style: body1)),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitPulse(
      color: color500,
      size: 50.0,
    );
    return GetBuilder<QuotationsCtrl>(
      init: QuotationsCtrl(),
      builder: (_ctrl) => Scaffold(
        appBar: AppBar(
          backgroundColor: color500,
          centerTitle: true,
          title: new Text(
            'Mis cotizaciones',
            style: subtituloblanco,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: color500,
          onPressed: () {
            Get.toNamed(Routes.NEWQUOTATIONS,
                arguments: {"editData": false, "data": null});
          },
        ),
        body: SafeArea(
          child: _ctrl.haveProducts == false
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Icon(LineIcons.cryingFace, size: 50, color: color500),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No tienes productos o servicios almacenados, presiona (+) para agregar uno nuevo.',
                        style: subtitulo,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : (_ctrl.quotationsList.quotations == null ||
                      _ctrl.quotationsList.quotations!.isEmpty)
                  ? Center(child: spinkit)
                  : RefreshIndicator(
                      color: color700,
                      onRefresh: () => _ctrl.getQuotations(null),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 14.0,
                              crossAxisSpacing: 1.0,
                              childAspectRatio: 1.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return myCards(
                                    quotation:
                                        _ctrl.quotationsList.quotations![index],
                                    index: index,
                                    context: context,
                                    ctrl: _ctrl);
                              },
                              childCount:
                                  _ctrl.quotationsList.quotations!.length,
                            ),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget myCards(
      {required QuotationModel quotation,
      required int index,
      required BuildContext context,
      required QuotationsCtrl ctrl}) {
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
            onTap: () => showProductDetail(context, quotation, ctrl, index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(quotation.title.toString(),
                      style: subtitulo,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 1,
                  ),
                  Text(quotation.customer!.name ?? '',
                      style: body1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 15,
                  ),
                  quotation.createAt != null
                      ? Text(
                          DateFormat.yMMMMEEEEd('es_US')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  quotation.createAt!))
                              .toString(),
                          style: body2,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center)
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      PDF().generateFile(quotation: quotation);
                    },
                    icon: Icon(
                      LineIcons.pdfFile,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  produsts({QuotationModel? quotation}) {
    List<Widget> _lista = [];
    quotation!.product!.products!
        .map(
          (e) => _lista.add(
            Column(
              children: [
                ListTile(
                    leading: Icon(LineIcons.tag, color: color500),
                    title: new Text(e.name.toString(), style: body1),
                    subtitle: new Text('producto', style: body2)),
                ListTile(
                    leading: Icon(LineIcons.moneyBill, color: color500),
                    title: new Text(e.price.toString(), style: body1),
                    subtitle: new Text('precio del producto', style: body2)),
              ],
            ),
          ),
        )
        .toList();
    _lista.addAll([
      ListTile(
          leading: Icon(LineIcons.tag, color: color500),
          title: new Text(
              DateFormat.yMMMMEEEEd('es_US')
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      quotation.expirationDate!))
                  .toString(),
              style: body1),
          subtitle: new Text('creado el', style: body2)),
      ListTile(
          leading: Icon(LineIcons.locationArrow, color: color500),
          title: new Text(quotation.customer!.email ?? '', style: body1),
          subtitle: new Text('Correo electrónico', style: body2)),
    ]);
    return _lista;
  }
}
