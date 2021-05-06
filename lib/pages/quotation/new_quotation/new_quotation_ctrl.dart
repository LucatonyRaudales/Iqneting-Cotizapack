import 'dart:async';
import 'dart:io';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/categories.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/pages/pdf/pdf_viewer.dart';
import 'package:cotizapack/repository/customer.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:cotizapack/repository/quotation.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NewQuotationCtrl extends GetxController{
  QuotationModel quotation = QuotationModel(product: ProductModel(name: '', category: null));
  QuotationRepository _quotationRepository = QuotationRepository();
  ProductRepository _productRepository = ProductRepository();
  RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  CustomerList _customerList = CustomerList();
  CustomerModel customerSelected = CustomerModel(name:'');
  ProductList _productList = ProductList();
  CustomerRepository _customerRepository = CustomerRepository();
  UserData _userData = UserData(category: UserCategory(collection: '', description: '', name: '', enable: true, id: ''));
  final doc = pw.Document();

  @override
  void onInit() {
    getCustomers();
    super.onInit();
  }

  void getCustomers()async{
    quotation.quantity = 1;
    quotation.expirationDate = DateTime.now().millisecondsSinceEpoch;
    _customerRepository.getMyCustomers()
      .then((value)async{
        _customerList = value;
        var data = (await MyGetStorage().listenUserData())!;
        quotation.userId = data.userID;
        getProducts();
      });
  }

  void getProducts()async{
    try{
      _productRepository.getProducts()
      .then((value){
          _productList = ProductList.fromJson( value!.data["documents"]);// value.data["documents"].map((i)=>ProductModel.fromJson(i)).toList(); 
          update();
      });
    }catch(e){
      print('Error get products: $e');
    }
  }

  void saveData(){
    _quotationRepository.createQuotation(
      quotation: quotation)
      .then((val){
        if(val == null){
          btnController.error();
          MyAlert.showMyDialog(title: 'Error al generar la cotización!', message: 'se produjo un error inesperado, intenta de nuevo.', color: Colors.red);
            return Timer(Duration(seconds: 3), ()=> this.btnController.reset());
        }
        switch (val.statusCode) {
          case 201:
            btnController.success();
            MyAlert.showMyDialog(title: 'Cotización guardado correctamente!', message: 'Se generará un pdf y lo podrás visualizar', color: Colors.green);
            generateFile(); 
            savePdf();
            break;
          default:
          this.btnController.reset();
          print('Error: ${val.statusMessage}');
        }
      });
  }


    void showPickerProduct(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: _productList.products!.isNotEmpty ? ListView.builder(
                    itemCount: _productList.products!.length,
                    itemBuilder: (ctx, index){
                      return InkWell(
                        onTap: (){
                          quotation.product = _productList.products![index];
                          update();
                          Navigator.pop(context);
                          },
                        child: ListTile(
                          trailing: new Icon(Icons.arrow_forward_ios, color: color500,),
                          title: new Text(_productList.products![index].name!, style: subtitulo,),
                          subtitle: new Text(_productList.products![index].description!, style: body2,),
                        ),
                      );
                    })
                    : new Center(
                      child: Column(children: [
                        new Text('No se encontraron datos.'),
                        SizedBox(height: 12,),
                        TextButton(
                          child: Text("¿Buscar de nuevo?", style: body1,),
                          onPressed:()=> getCustomers(),
                        ),
                      ],)
                    ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

    void showPicker(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: _customerList.customers!.isNotEmpty ? ListView.builder(
                    itemCount: _customerList.customers!.length,
                    itemBuilder: (ctx, index){
                      return InkWell(
                        onTap: (){
                          customerSelected = _customerList.customers![index];
                          quotation.clientID = customerSelected.id;
                          quotation.clientName = customerSelected.name;
                          quotation.email = customerSelected.email;
                          update();
                          Navigator.pop(context);
                          },
                        child: ListTile(
                          trailing: new Icon(Icons.arrow_forward_ios, color: color500,),
                          title: new Text(_customerList.customers![index].name!, style: subtitulo,),
                          subtitle: new Text(_customerList.customers![index].address!, style: body2,),
                        ),
                      );
                    })
                    : new Center(
                      child: Column(children: [
                        new Text('No se encontraron datos.'),
                        SizedBox(height: 12,),
                        TextButton(
                          child: Text("¿Buscar de nuevo?", style: body1,),
                          onPressed:()=> getCustomers(),
                        ),
                      ],)
                    ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  // the function
  void generateFile() async {
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
                      new pw.Text(customerSelected.name!.toUpperCase(), textAlign: pw.TextAlign.left),
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
  }
    Future savePdf() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(await doc.save());
    Timer(Duration(seconds:2), ()=>Get.to(()=>PdfPreviewScreen(path: file.path,)));
  }
}