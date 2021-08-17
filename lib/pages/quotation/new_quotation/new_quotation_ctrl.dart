import 'dart:async';
import 'dart:io';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/ModelPDF.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/model/file.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/repository/customer.dart';
import 'package:cotizapack/repository/products.dart';
import 'package:cotizapack/repository/quotation.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/repository/user.dart';
import 'package:cotizapack/settings/generate_pdf.dart';
import 'package:cotizapack/settings/get_image.dart';
import 'package:cotizapack/settings/get_storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NewQuotationCtrl extends GetxController with StateMixin {
  QuotationModel quotation = QuotationModel(
    product: new ProductList(products: []),
    images: [],
  );
  QuotationRepository _quotationRepository = QuotationRepository();
  ProductRepository _productRepository = ProductRepository();
  RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();
  RoundedLoadingButtonController btnControllerSave =
      new RoundedLoadingButtonController();
  CustomerList _customerList = CustomerList();
  CustomerModel customerSelected = CustomerModel(name: '');
  ProductList _productList = ProductList();
  CustomerRepository _customerRepository = CustomerRepository();
  // UserData _userData = UserData(
  //     category: UserCategory(
  //         collection: '', description: '', name: '', enable: true, id: ''));
  late MyFile myFile;
  RxInt activeStep = 0.obs;
  RxInt dotCount = 4.obs;
  List<File?> images = [];
  ProductModel productModelTemp = new ProductModel(category: ProductCategory());
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void onInit() {
    quantityController.text = "1";
    getCustomers();
    super.onInit();
  }

  void getCustomers() async {
    quotation.expirationDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
        .millisecondsSinceEpoch;
    _customerRepository.getMyCustomers().then((value) async {
      _customerList = value;
      if (_customerList.customers!.isEmpty)
        change(null, status: RxStatus.empty());
      if (value.customers!.length == 0) {
        Get.back();
        return MyAlert.showMyDialog(
          title: 'Error',
          message: 'no hay clientes registrados.',
          color: Colors.red,
        );
      }
      var data = (await MyGetStorage().listenUserData());
      quotation.userId = data.userID;
      getProducts();
    });
  }

  void getProducts() async {
    try {
      change(null,
          status: RxStatus
              .loading()); // value.data["documents"].map((i)=>ProductModel.fromJson(i)).toList();
      _productRepository.getProducts().then((value) {
        _productList = ProductList.fromJson(value!.data["documents"]);
        change(null,
            status: RxStatus
                .success()); // value.data["documents"].map((i)=>ProductModel.fromJson(i)).toList();
        update();
        if (_productList.products!.isEmpty) {
          Get.back();
          return MyAlert.showMyDialog(
            title: 'Error',
            message: 'No hay productos primero registre un producto ',
            color: Colors.red,
          );
        }
      });
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      print('Error get products: $e');
    }
  }

  Future<bool> uploadImage(File image) async {
    var imgres = await MyStorage().postFile(file: image);
    if (imgres != null) {
      myFile = MyFile.fromJson(imgres.data);
      print('Me Guarde');
      return true;
    }
    print('No se subio esa vaina');
    btnController.error();
    MyAlert.showMyDialog(
        title: 'Error al guardar la imagen',
        message: 'por favor, intenta de nuevo',
        color: Colors.red);
    Timer(Duration(seconds: 3), () {
      btnController.reset();
    });
    return false;
  }

  Future<bool> validatepackages() async {
    var user = await UserRepository().chargeUserData(userID: quotation.userId!);
    if (user.quotations! == 0) return false;
    await UserRepository()
        .updateMyPackages(data: user, quotation: (user.quotations! - 1));
    return true;
  }

  saveData() async {
    try {
      change(null, status: RxStatus.loading());
      for (var e in images) {
        var a = await uploadImage(e!);
        if (a) quotation.images?.add(myFile.id!);
      }
      var subTotal = 0.0;
      for (var i in quotation.product!.products!) {
        subTotal += (i.price! * i.quantity!);
      }
      quotation.subTotal = subTotal;
      double ivs = subTotal * (0.15); //real = (ivs/100)+1;
      quotation.total = ivs + subTotal;
      printInfo(info: subTotal.toString());
      var val =
          await _quotationRepository.createQuotation(quotation: quotation);
      if (val == null) {
        change(null, status: RxStatus.error());
        btnController.error();
        MyAlert.showMyDialog(
            title: 'Error al generar la cotización!',
            message: 'se produjo un error inesperado, intenta de nuevo.',
            color: Colors.red);
        return Timer(Duration(seconds: 3), () => this.btnController.reset());
      }
      switch (val.statusCode) {
        case 201:
          change(null, status: RxStatus.success());
          btnController.success();
          MyAlert.showMyDialog(
              title: 'Cotización guardado correctamente!',
              message: 'Se generará un pdf y lo podrás visualizar',
              color: Colors.green);
          PDF().generateFile(quotation: quotation);
          break;
        default:
          change(null, status: RxStatus.error(val.statusMessage));
          MyAlert.showMyDialog(
              title: 'Error al generar la cotización!',
              message: '${val.statusMessage}',
              color: Colors.green);
          this.btnController.reset();
          print('Error: ${val.statusMessage}');
      }
    } catch (e) {}
  }

  void showPickerProduct(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          height: 300,
          child: this.obx(
            (s) => Container(
              child: _productList.products!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _productList.products?.length ?? 0,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            productModelTemp = ProductModel.fromJson(
                                _productList.products![index].toJson());
                            if (quantityController.text != "") {
                              priceController.text =
                                  (double.parse(quantityController.text) *
                                          productModelTemp.price!.toDouble())
                                      .toString();

                              productModelTemp.quantity =
                                  int.parse(quantityController.text);
                            }
                            print(quotation.product);
                            update();
                            Get.back();
                          },
                          child: ListTile(
                            trailing: new Icon(
                              Icons.arrow_forward_ios,
                              color: color500,
                            ),
                            title: new Text(
                              _productList.products![index].name!,
                              style: subtitulo,
                            ),
                            subtitle: new Text(
                              _productList.products![index].description!,
                              style: body2,
                            ),
                          ),
                        );
                      })
                  : new Center(
                      child: Column(
                      children: [
                        new Text('No se encontraron datos.'),
                        SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          child: Text(
                            "¿Buscar de nuevo?",
                            style: body1,
                          ),
                          onPressed: () => getCustomers(),
                        ),
                      ],
                    )),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
            onLoading: Center(
              child: SpinKitPulse(
                color: color500,
                size: 50.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Future getImage({required ImageSource source}) async {
    if (images.length > 2) return print('Demaciadas Imagenes');
    File? img = await GetImage().getImage(source: source);
    if (img != null) images.add(img);
    Get.back();
    update();
  }

  addproductinList(ProductModel productModel) {
    if (quotation.product!.products!.length == 4)
      return MyAlert.showMyDialog(
          title: 'Error',
          message: 'Ha alcanzado el maximo numero de productos',
          color: Colors.red);
    bool updateProduct = false;
    quotation.product?.products?.forEach((e) {
      if (e.id == productModel.id) {
        e.quantity = e.quantity! + productModel.quantity!;
        updateProduct = true;
      }
    });
    if (!updateProduct) quotation.product?.products?.add(productModel);

    productModelTemp = ProductModel(category: ProductCategory());
    MyAlert.showMyDialog(
        title: 'Producto guardado correctamente!',
        message: 'Seleccione otro producto si es requerido.',
        color: Colors.green);
    btnControllerSave.success();
    Timer(Duration(seconds: 1), () {
      quantityController.text = "1";
      btnControllerSave.reset();
      update();
    });
  }

  void showPicker(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          height: Get.height / 2.4,
          child: Container(
            child: _customerList.customers!.length > 0
                ? ListView.builder(
                    itemCount: _customerList.customers!.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          customerSelected = _customerList.customers![index];
                          quotation.customer = customerSelected;
                          update();
                          Get.back();
                        },
                        child: ListTile(
                          trailing: new Icon(
                            Icons.arrow_forward_ios,
                            color: color500,
                          ),
                          title: new Text(
                            _customerList.customers![index].name!,
                            style: subtitulo,
                          ),
                          subtitle: new Text(
                            _customerList.customers![index].address!,
                            style: body2,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No tienes clientes guardadas.',
                          style: subtitulo,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          child: Text(
                            "¿Buscar de nuevo?",
                            style: body1,
                          ),
                          onPressed: () => getCustomers(),
                        ),
                      ],
                    ),
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
      },
    );
  }
}
