import 'dart:async';
import 'dart:io';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/pdf/pdf_viewer.dart';
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
    fontSize: 19,
  );

  // the function
  void generateFile(
      {required QuotationModel quotation, UserData? userData}) async {
    var img = await networkImage(
        userData?.logo ?? 'https://via.placeholder.com/288x188');

    userData = (await MyGetStorage().listenUserData())!;
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Header(
                  level: 0,
                  child: new pw.Column(
                    children: [
                      _infodate(quotation: quotation),
                      pw.Container(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            imageLogo(img),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                                child: dataEmisor(quotation: quotation)),
                            pw.Expanded(
                                child: dataReceptor(quotation: quotation)),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      titleBlue(quotation: quotation),
                    ],
                  ),
                ),
                pw.Table(
                  children: [
                    headerTable(),
                    listDetailTable(quotation: quotation, color: '#FFFFFFFF'),
                  ],
                ),
                detalle(quotation),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                    width: 315,
                    child: pw.Table(
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#E4E2E2'),
                            border: pw.Border(
                              bottom: pw.BorderSide(width: 1),
                            ),
                          ),
                          children: [
                            pw.Text("Total: ".toUpperCase(), style: estilo),
                            pw.Expanded(
                              child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.only(right: 15),
                                  child: pw.Text(quotation.subTotal.toString(),
                                      style: estilo),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
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
    //savePdf(name: quotation.title!);
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/${quotation.title}.pdf");

    file.writeAsBytesSync(await doc.save());
    if (file.path.isNotEmpty) {
      Get.to(() => PdfPreviewScreen(), arguments: file);
    } else {
      generateFile(quotation: quotation);
    }
    //Timer(Duration(seconds:2), ()=>Get.to(()=>PdfPreviewScreen(file: file,)));
  }

  pw.Expanded detalle(QuotationModel quotation) {
    return pw.Expanded(
        child: pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        alignment: pw.Alignment.bottomRight,
        child: pw.Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#E4E2E2'),
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1),
                ),
              ),
              children: [
                pw.Text("Sub Total: ".toUpperCase(), style: estilo),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(right: 15),
                      child:
                          pw.Text(quotation.subTotal.toString(), style: estilo),
                    ),
                  ),
                )
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1),
                ),
              ),
              children: [
                pw.Text("IVA: ", style: estilo),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(right: 15),
                      child:
                          pw.Text(quotation.subTotal.toString(), style: estilo),
                    ),
                  ),
                )
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#E4E2E2'),
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1),
                ),
              ),
              children: [
                pw.Text("ANTICIPO: ", style: estilo),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(right: 15),
                      child:
                          pw.Text(quotation.subTotal.toString(), style: estilo),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  pw.Column imageLogo(pw.ImageProvider img) {
    return pw.Column(
      children: [
        pw.Text('COTIZACIÓN', style: estilo.copyWith(fontSize: 18)),
        pw.Container(
          width: 100,
          height: 100,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Center(child: pw.Image(img)),
        ),
      ],
    );
  }

  pw.TableRow listDetailTable(
      {required QuotationModel quotation, String? color}) {
    return pw.TableRow(
      repeat: true,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex(color ?? '#BCBCBC'),
        border: pw.Border(
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              quotation.quantity.toString(),
              style: pw.TextStyle(fontSize: 19.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              quotation.description.toString().toUpperCase(),
              style: pw.TextStyle(fontSize: 19.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              (quotation.subTotal! / quotation.quantity!).toStringAsFixed(2),
              style: pw.TextStyle(fontSize: 19.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              quotation.subTotal!.toStringAsFixed(2),
              style: pw.TextStyle(fontSize: 19.0),
            )
          ],
        ),
      ],
    );
  }

  pw.TableRow headerTable() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#BCBCBC'),
        border: pw.Border(
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      children: [
        pw.Column(
          children: [
            pw.Text(
              'CANTIDAD',
              style: pw.TextStyle(fontSize: 20.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'CONCEPTO(S)',
              style: pw.TextStyle(fontSize: 20.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'PRECIO',
              style: pw.TextStyle(fontSize: 20.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'TOTAL',
              style: pw.TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ],
    );
  }

  pw.Container titleBlue({required QuotationModel quotation}) {
    return pw.Container(
      height: 100,
      width: 500,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#00B7F4'),
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              'PROYECTO',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 25,
                fontBold: pw.Font.timesBold(),
              ),
            ),
            pw.Text(
              quotation.title.toString() +
                  ' / ' +
                  quotation.description.toString(),
              style: pw.TextStyle(
                fontSize: 25,
                fontBold: pw.Font.timesBold(),
              ),
              textAlign: pw.TextAlign.right,
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
    return new pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'FECHA: ' +
                DateFormat.yMd('es_US').format(
                  DateTime.now(),
                ),
            textAlign: pw.TextAlign.right,
          ),
          pw.Text(
            'FOLIO: ' + quotation.collection.toString(),
            textAlign: pw.TextAlign.right,
          ),
          pw.Text(
            'ORDEN: ' + quotation.id.toString(),
            textAlign: pw.TextAlign.right,
          ),
          pw.Text(
            'VIGENCIA: ' +
                DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(
                    quotation.expirationDate!)),
            textAlign: pw.TextAlign.right,
          ),
        ],
      ),
    );
  }

  dataEmisor({required QuotationModel quotation}) {
    final estilo = pw.TextStyle(
      fontSize: 16,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Emisor: ', style: estilo),
        pw.Text('Nombre: ', style: estilo),
        pw.Text('RFC: ', style: estilo),
        pw.Text('Telefono: ', style: estilo),
        pw.Text('Email: ', style: estilo),
        pw.Text('Dirección: ', style: estilo),
      ],
    );
  }

  dataReceptor({required QuotationModel quotation}) {
    final estilo = pw.TextStyle(
      fontSize: 16,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Receptor: ', style: estilo),
        pw.Text('Nombre: ', style: estilo),
        pw.Text('RFC: ', style: estilo),
        pw.Text('Telefono: ', style: estilo),
        pw.Text('Email: ', style: estilo),
        pw.Text('Dirección: ', style: estilo),
      ],
    );
  }
}
