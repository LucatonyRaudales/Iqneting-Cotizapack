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

class PDF{
  UserData _userData = UserData(category: UserCategory(collection: '', description: '', name: '', enable: true, id: ''));
  final doc = pw.Document();
  // the function
  void generateFile({required QuotationModel quotation}) async {
    _userData = (await MyGetStorage().listenUserData())!;
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(15),
            child: pw.Column(
              children: [
                pw.Header(
                  level: 0,
                  child: new pw.Column(
                    children: [
                      new pw.Center(
                        child: pw.Text(DateFormat.yMMMMEEEEd('es_US').format(DateTime.now()), textAlign: pw.TextAlign.right),
                      ),
                      pw.SizedBox(height: 20),
                      new pw.Text(_userData.businessName!.toUpperCase(), textAlign: pw.TextAlign.left),
                      pw.SizedBox(height: 10),
                      new pw.Text(quotation.clientName!.toUpperCase(), textAlign: pw.TextAlign.left),
                      pw.SizedBox(height: 10),
                      new pw.Text('PRESENTE:', textAlign: pw.TextAlign.left, )
                    ]
                  )
                ),
                pw.SizedBox(height: 30),
                new pw.Text(quotation.title!, textAlign: pw.TextAlign.right),
                new pw.Text(quotation.description!, textAlign: pw.TextAlign.right),
                pw.SizedBox(height: 30),
                pw.Header(
                  level: 0,
                  child: new pw.Column(
                    children: [
                      new pw.Text('Propuesta Económica', textAlign: pw.TextAlign.center),
                      new pw.Container(
                        child: pw.Column(
                          children: [
                            new pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                new pw.Text('Concepto: '),
                                new pw.Text('Cantidad: '),
                                new pw.Text('Precio: ')
                              ]
                            ),
                            new pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                new pw.Text(quotation.description!),
                                new pw.Text(quotation.quantity!.toString()),
                                new pw.Text(quotation.subTotal!.toString())
                              ]
                            ),
                            new pw.Text('Total USD ${quotation.subTotal! * quotation.quantity!}', textAlign: pw.TextAlign.right),
                          ]
                        )
                      )
                    ]
                  )
                ),
              ]
            )
          );
        }
      ),
    );
      //savePdf(name: quotation.title!);
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/${quotation.title}.pdf");

    file.writeAsBytesSync(await doc.save());
    if(file.path.isNotEmpty){
      Get.to(()=>PdfPreviewScreen(file: file), arguments: file);
    }else{
      generateFile(quotation: quotation);
    }
   //Timer(Duration(seconds:2), ()=>Get.to(()=>PdfPreviewScreen(file: file,)));
  }



    Future savePdf({required String name}) async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/$name.pdf");

    file.writeAsBytesSync(await doc.save());
    if(file.path.isNotEmpty){
      Get.to(()=>PdfPreviewScreen(file: file,), arguments: file);
    }
  }
}