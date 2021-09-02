import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cotizapack/model/ModelPDF.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/pdf/pdf_viewer.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDF {
  final doc = pw.Document();
  final estilo = pw.TextStyle(
    fontSize: 14,
  );

  late UserData? _userData;
  // the function
  void generateFile({required QuotationModel quotation}) async {
    _userData = (await MyGetStorage().listenUserData());
    _userData!.logo = _userData!.logo == '' ? null : _userData!.logo;
    var img = _userData!.logo == null
        ? await networkImage("https://via.placeholder.com/288x188")
        : await MyStorage().getFilePreview(fileId: _userData!.logo!);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                pw.Header(
                  level: 0,
                  child: new pw.Column(
                    children: [
                      _headerPage(img, userData: _userData!),
                      pw.SizedBox(width: 60),
                      pw.Divider(
                        thickness: 4,
                        color: PdfColor.fromHex("#D6D6D6"),
                      ),
                      pw.SizedBox(width: 60),
                      pw.Container(
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                                flex: 4,
                                child: dataReceptor(quotation: quotation)),
                            pw.SizedBox(width: 10),
                            pw.Flexible(
                                flex: 3, child: _infodate(quotation: quotation))
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: textCuston(
                              'Proyecto. ' + quotation.title!, estilo)),
                    ],
                  ),
                ),
                pw.Table(
                  children: tableDetail(quotation),
                ),
                pw.Divider(
                  thickness: 4,
                  color: PdfColor.fromHex("#D6D6D6"),
                ),
                detalle(quotation),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: textCuston(
                    'NO INCLUYE ENVIO',
                    pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Divider(
                  thickness: 2,
                  color: PdfColor.fromHex("#D6D6D6"),
                ),
                textCuston(
                  'Al frmar este documento, el cliente acepta los servicios y condiciones descritos en este contrato.',
                  pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.center,
                              child:
                                  textCuston('${_userData!.ceoName!}', estilo),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    bottom: pw.BorderSide(
                                      width: 2,
                                      color: PdfColor.fromHex("#D6D6D6"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Align(
                              alignment: pw.Alignment.center,
                              child: textCuston(
                                  DateFormat.yMMMd("es_MX").format(
                                    DateTime.now(),
                                  ),
                                  estilo),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 30),
                      pw.Expanded(
                        child: pw.Column(
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.center,
                              child: textCuston(
                                  '${quotation.customer!.name!}', estilo),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    bottom: pw.BorderSide(
                                      width: 2,
                                      color: PdfColor.fromHex("#D6D6D6"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Align(
                              alignment: pw.Alignment.center,
                              child: textCuston('(     /    /     )', estilo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Footer(
                  title: pw.Text(
                    'Documento sin validez fiscal. || COTIZAPACK.COM',
                    style: estilo..copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (quotation.images!.length > 0) {
      List<Uint8List> images = [];
      for (var i in quotation.images!) {
        var tempImg = await MyStorage().getFilePreview(fileId: i!);
        images.add(tempImg!);
      }
      otherimages() {
        List<pw.Widget> listwidgets = [];
        images.map((e) {
          listwidgets.add(
            pw.Container(
              decoration:
                  pw.BoxDecoration(border: pw.Border.all(width: 1), boxShadow: [
                pw.BoxShadow(
                  blurRadius: 1,
                  offset: PdfPoint(10, 20),
                  color: PdfColor.fromHex('#E4E2E2'),
                  spreadRadius: 2.0,
                ),
              ]),
              width: 200,
              height: 200,
              child: pw.Image(
                pw.MemoryImage(e),
              ),
            ),
          );
        }).toList();
        return listwidgets;
      }

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter,
          build: (pw.Context context) {
            return pw.Container(
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: otherimages(),
              ),
            );
          },
        ),
      );
    }
    //savePdf(name: quotation.title!);
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/${quotation.title}.pdf");

    file.writeAsBytesSync(await doc.save());
    if (file.path.isNotEmpty) {
      Get.toNamed(Routes.GENERATEPDF, arguments: file);
    } else {
      generateFile(quotation: quotation);
    }
    //Timer(Duration(seconds:2), ()=>Get.to(()=>PdfPreviewScreen(file: file,)));
  }

  List<pw.TableRow> tableDetail(QuotationModel quotation) {
    var list = [
      headerTable(),
    ];

    for (var i = 0; i < quotation.product!.products!.length; i++) {
      var e = quotation.product!.products![i];
      list.add(
        listDetailTable(product: e, color: i % 2 == 0 ? '#ffffffff' : null),
      );
    }

    return list;
  }

  pw.Column detalle(QuotationModel quotation) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            width: 250,
            alignment: pw.Alignment.bottomRight,
            child: pw.Column(
              children: [
                pw.SizedBox(height: 20),
                pw.Table(
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                            child: pw.Text("Subtotal ", style: estilo),
                            padding: pw.EdgeInsets.only(bottom: 8)),
                        pw.Expanded(
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(bottom: 8),
                              child: pw.Text(
                                  quotation.subTotal.toString() + " \$",
                                  style: estilo),
                            ),
                          ),
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                            child: pw.Text("IVA (16%)", style: estilo),
                            padding: pw.EdgeInsets.only(bottom: 8)),
                        pw.Expanded(
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(bottom: 8),
                              child: pw.Text(
                                  (quotation.subTotal! * 0.16)
                                          .toStringAsFixed(1) +
                                      " \$",
                                  style: estilo),
                            ),
                          ),
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                            child: pw.Text("Total", style: estilo),
                            padding: pw.EdgeInsets.only(bottom: 8)),
                        pw.Expanded(
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(bottom: 8),
                              child: pw.Text(
                                  (quotation.subTotal! * 1.16)
                                          .toStringAsFixed(1) +
                                      " \$",
                                  style: estilo),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                pw.Divider(
                  thickness: 4,
                  color: PdfColor.fromHex("#D6D6D6"),
                ),
              ],
            ),
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            width: 315,
            child: pw.Table(
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EBEBEB'),
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 2,
                        color: PdfColor.fromHex('#D6D6D6'),
                      ),
                    ),
                  ),
                  children: [
                    pw.Padding(
                      child: pw.Text(
                        "Saldo deudor",
                        style: estilo.copyWith(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      padding: pw.EdgeInsets.all(8),
                    ),
                    pw.Expanded(
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          child: pw.Text(
                            (quotation.subTotal! * 1.16).toStringAsFixed(1) +
                                " \$",
                            style: estilo.copyWith(
                              color: PdfColor.fromHex("#3F6501"),
                            ),
                          ),
                          padding: pw.EdgeInsets.all(8),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Column imageLogo(img) {
    return pw.Column(
      children: [
        pw.Container(
          width: 80,
          height: 80,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Center(
            child: pw.Image(
              _userData!.logo == null ? img : pw.MemoryImage(img),
              fit: pw.BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  pw.TableRow listDetailTable({required ProductModel product, String? color}) {
    return pw.TableRow(
      repeat: true,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex(color ?? '#EBEBEB'),
      ),
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: textCuston(
                  product.name.toString(),
                  pw.TextStyle(fontSize: 14.0, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(
                  product.quantity.toString(),
                  style: pw.TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(
                  (product.price!).toStringAsFixed(2) + " \$",
                  style: pw.TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(
                  (product.price! * product.quantity!).toStringAsFixed(2) +
                      " \$",
                  style: pw.TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.TableRow headerTable() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#DEEDF7'),
        border: pw.Border(
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(
                  'Artículo',
                  style: pw.TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                'Cantidad',
                style: pw.TextStyle(fontSize: 15.0),
              ),
            )
          ],
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                'Precio',
                style: pw.TextStyle(fontSize: 15.0),
              ),
            )
          ],
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(
                'Importe',
                style: pw.TextStyle(fontSize: 15.0),
              ),
            )
          ],
        ),
      ],
    );
  }

  pw.Container titleBlue({required QuotationModel quotation}) {
    return pw.Container(
      height: 100,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#00B7F4'),
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Expanded(
              child: pw.Center(
                child: pw.Text(
                  'PROYECTO',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontBold: pw.Font.timesBold(),
                  ),
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    pw.Expanded(
                      flex: 8,
                      child: pw.Container(
                        child: pw.Text(
                          quotation.title!,
                          maxLines: 2,
                          softWrap: true,
                          overflow: pw.TextOverflow.clip,
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontBold: pw.Font.timesBold(),
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Text(
                          '/',
                          style: pw.TextStyle(
                            fontSize: 25,
                            fontBold: pw.Font.timesBold(),
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 8,
                      child: pw.Text(
                        quotation.description!,
                        maxLines: 2,
                        softWrap: true,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontBold: pw.Font.timesBold(),
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future savePdf({required String name}) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/$name.pdf");

    file.writeAsBytesSync(await doc.save());
    if (file.path.isNotEmpty) {
      Get.to(() => PdfPreviewScreen(), arguments: file);
    }
  }

  _infodate({required QuotationModel quotation}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Cotización #',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              quotation.id.toString(),
              textAlign: pw.TextAlign.right,
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Fecha ',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              DateFormat.yMMMd("es_MX").format(
                DateTime.fromMicrosecondsSinceEpoch(
                  quotation.createAt ?? 0,
                ),
              ),
              textAlign: pw.TextAlign.right,
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Vencimiento ',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              DateFormat.yMMMd("es_MX").format(
                DateTime.fromMillisecondsSinceEpoch(
                  quotation.expirationDate!,
                ),
              ),
              textAlign: pw.TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  _headerPage(img, {required UserData userData}) {
    return new pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          imageLogo(img),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('COTIZACIÓN',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(userData.ceoName!,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(
                userData.phone!,
                textAlign: pw.TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  dataReceptor({required QuotationModel quotation}) {
    final estilo = pw.TextStyle(
      fontSize: 14,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Para', style: estilo.copyWith(fontWeight: pw.FontWeight.bold)),
        textCuston('${quotation.customer!.rfc!}', estilo),
        textCuston('${quotation.customer!.name!}', estilo),
        textCuston('${quotation.customer!.address!}', estilo),
      ],
    );
  }

  pw.Text textCuston(String text, pw.TextStyle estilo) {
    return pw.Text(
      text,
      maxLines: 2,
      softWrap: true,
      overflow: pw.TextOverflow.clip,
      style: estilo,
    );
  }
}
