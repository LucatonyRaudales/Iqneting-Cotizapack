import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cotizapack/model/ModelPDF.dart';
import 'package:cotizapack/model/my_account.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/pdf/pdf_viewer.dart';
import 'package:cotizapack/repository/account.dart';
import 'package:cotizapack/repository/storage.dart';
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
  late MyAccount? _accountData;
  AccountRepository _accountRepository = AccountRepository();
  // the function
  void generateFile({required QuotationModel quotation}) async {
    _userData = (await MyGetStorage().listenUserData());
    _accountData = (await _accountRepository.getAccount())!;
    _userData!.logo = _userData!.logo == '' ? null : _userData!.logo;
    var img = _userData!.logo == null
        ? networkImage("https://via.placeholder.com/288x188")
        : await MyStorage().getFilePreview(fileId: _userData!.logo!);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
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
                      pw.SizedBox(width: 30),
                      pw.Container(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            imageLogo(img),
                            pw.SizedBox(width: 10),
                            pw.Expanded(child: dataEmisor()),
                            pw.VerticalDivider(
                              thickness: 0,
                              color: PdfColor.fromHex('#00000000'),
                            ),
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
                  children: tableDetail(quotation),
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
      Get.to(() => PdfPreviewScreen(), arguments: file);
    } else {
      generateFile(quotation: quotation);
    }
    //Timer(Duration(seconds:2), ()=>Get.to(()=>PdfPreviewScreen(file: file,)));
  }

  List<pw.TableRow> tableDetail(QuotationModel quotation) {
    var list = [
      headerTable(),
    ];
    quotation.product!.products!
        .map(
          (e) => list.add(
            listDetailTable(product: e, color: '#ffffffff'),
          ),
        )
        .toList();
    return list;
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
                      child: pw.Text(0.0.toString(), style: estilo),
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
                      child: pw.Text(0.0.toString(), style: estilo),
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

  pw.Column imageLogo(img) {
    return pw.Column(
      children: [
        pw.Text('COTIZACIÓN', style: estilo.copyWith(fontSize: 18)),
        pw.Container(
          width: 100,
          height: 100,
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

  dataEmisor() {
    final estilo = pw.TextStyle(
      fontSize: 14,
    );
    if (_userData == null) return pw.Text('No hay data');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Emisor ',
            style: estilo.copyWith(fontWeight: pw.FontWeight.bold)),
        pw.Text('Nombre: ${_userData!.ceoName}', style: estilo),
        pw.Text('RFC: ${_userData!.rfc}', style: estilo),
        pw.Text('Telefono: ${_userData!.phone}', style: estilo),
        pw.Text('Email: ${_accountData!.email}', style: estilo),
        pw.Text('Dirección: ${_userData!.address}', style: estilo),
      ],
    );
  }

  pw.TableRow listDetailTable({required ProductModel product, String? color}) {
    return pw.TableRow(
      repeat: true,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex(color ?? '#BCBCBC'),
        border: pw.Border(
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                product.quantity.toString(),
                style: pw.TextStyle(fontSize: 14.0),
              )
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            children: [
              textCuston(
                product.name.toString().toUpperCase(),
                pw.TextStyle(fontSize: 14.0),
              )
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text(
                (product.price!).toStringAsFixed(2),
                style: pw.TextStyle(fontSize: 14.0),
              )
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text(
                (product.price! * product.quantity!).toStringAsFixed(2),
                style: pw.TextStyle(fontSize: 14.0),
              )
            ],
          ),
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
              style: pw.TextStyle(fontSize: 15.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'CONCEPTO(S)',
              style: pw.TextStyle(fontSize: 15.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'PRECIO',
              style: pw.TextStyle(fontSize: 15.0),
            )
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'TOTAL',
              style: pw.TextStyle(fontSize: 15.0),
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
    return new pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'FECHA: ' +
                DateFormat("dd-MM-yy").format(
                  DateTime.now(),
                ),
            textAlign: pw.TextAlign.right,
          ),
          pw.Text(
            'FOLIO: ' + quotation.id.toString(),
            textAlign: pw.TextAlign.right,
          ),
          pw.Text(
            'VIGENCIA: ' +
                DateFormat("dd-MM-yy").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        quotation.expirationDate!)),
            textAlign: pw.TextAlign.right,
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
        pw.Text('Receptor: ',
            style: estilo.copyWith(fontWeight: pw.FontWeight.bold)),
        textCuston('Nombre: ${quotation.customer!.name!}', estilo),
        textCuston('RFC: ${quotation.customer!.rfc!}', estilo),
        textCuston('Telefono: ${quotation.customer!.phone!}', estilo),
        textCuston('Email: ${quotation.customer!.email!}', estilo),
        textCuston('Dirección: ${quotation.customer!.address!}', estilo),
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
