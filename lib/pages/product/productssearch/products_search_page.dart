import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/products/products_ctrl.dart';
import 'package:cotizapack/pages/product/productssearch/products_search_crtl.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class PorductSearchPage extends GetResponsiveView<ProductsSearchController> {
  void showProductDetail(
      BuildContext context, ProductModel product, Uint8List image) {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                ),
                image: DecorationImage(
                  image: MemoryImage(
                    image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(product.name!, style: subtitulo),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(product.description!, style: body1),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(LineIcons.moneyBill, color: color500),
                  title: new Text(product.type == 1 ? 'Servicio' : 'Producto',
                      style: body1),
                  subtitle: new Text('Tipo', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.moneyBill, color: color500),
                  title: new Text(product.price.toString(), style: body1),
                  subtitle: new Text('Precio', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.tag, color: color500),
                  title: new Text(product.category!.name!, style: body1),
                  subtitle: new Text('Categoría', style: body2),
                ),
                ListTile(
                  leading: Icon(LineIcons.locationArrow, color: color500),
                  title: new Text(product.category!.description!, style: body1),
                  subtitle:
                      new Text('Descripción de la categoría', style: body2),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: 45,
                width: double.infinity / 1.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsSearchController>(
      builder: (_ctrl) => Scaffold(
        appBar: AppBar(
          backgroundColor: color500,
          centerTitle: true,
          title: new Text(
            'Productos',
            style: subtituloblanco,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _ctrl.createNewProduct(),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _widgetsearch(_ctrl),
              Expanded(
                child: _ctrl.products.length != 0
                    ? CustomScrollView(
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
                                final product = _ctrl.products[index];
                                return myCards(
                                  product: product,
                                  index: index,
                                  context: context,
                                );
                              },
                              childCount: _ctrl.products.length,
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Center(
                          child: SpinKitPulse(
                            color: color500,
                            size: 50.0,
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

  Widget _widgetsearch(ProductsSearchController _ctrl) {
    // Timer timer = Timer(Duration(seconds: 2), () {});
    return Container(
      child: ExpansionTile(
        trailing: Icon(Icons.filter_list),
        initiallyExpanded: true,
        title: Text('Filtro'),

        // Form(
        //   key: _ctrl.formKey,
        //   child: InputText(
        //     name: 'Buscar',
        //     textInputType: TextInputType.name,
        //     validator: Validators.nameValidator,
        //     prefixIcon: Icon(LineIcons.search),
        //     onChanged: (string) {
        //       timer.cancel();
        //       timer = Timer(Duration(seconds: 2), () {
        //         _ctrl.searchProduct();
        //       });
        //     },
        //   ),
        // ),
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: Obx(
                          () => DropdownButton<String>(
                            value: _ctrl.typeopcion.value.length == 0
                                ? null
                                : _ctrl.typeopcion.value,
                            hint: Text('Tipo'),
                            isExpanded: false,
                            onChanged: (opt) {
                              _ctrl.typeopcion.value = opt!;
                              _ctrl.searchProduct();
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 35.0,
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text('Producto'),
                                value: 'Producto',
                              ),
                              DropdownMenuItem(
                                child: Text('Servicio'),
                                value: 'Servicio',
                              )
                            ],
                            underline: null,
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: Obx(
                          () => DropdownButton<String>(
                            value: _ctrl.ordenprice.value.length == 0
                                ? null
                                : _ctrl.ordenprice.value,
                            hint: Text('Precio Orden'),
                            isExpanded: false,
                            onChanged: (opt) {
                              _ctrl.ordenprice.value = opt!;
                              _ctrl.searchProduct();
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 35.0,
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text('Mayor a menor'),
                                value: 'Mayor a menor',
                              ),
                              DropdownMenuItem(
                                child: Text('Menor a mayor'),
                                value: 'Menor a mayors',
                              )
                            ],
                            underline: null,
                          ),
                        ),
                      )
                    ],
                  ),
                  DropdownButtonHideUnderline(
                    child: Obx(
                      () => DropdownButton<String>(
                        value: _ctrl.orderAZ.value.length == 0
                            ? null
                            : _ctrl.orderAZ.value,
                        hint: Text('Order Seleccione'),
                        isExpanded: false,
                        onChanged: (opt) {
                          _ctrl.orderAZ.value = opt!;
                          _ctrl.orderproductnamed(revers: opt);
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 35.0,
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text('A-Z'),
                            value: 'A-Z',
                          ),
                          DropdownMenuItem(
                            child: Text('Z-A'),
                            value: 'Z-A',
                          )
                        ],
                        underline: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget myCards({
    required ProductModel product,
    required int index,
    required BuildContext context,
  }) {
    final ProductsCtrl ctrl = Get.find();
    Uint8List image = Uint8List(0);
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
            onLongPress: () => showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25),
                      topRight: const Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      new Text(product.name!, style: subtitulo),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.to(NewProductPage(),
                                        transition:
                                            Transition.rightToLeftWithFade,
                                        arguments: {
                                          "editData": true,
                                          "data": product
                                        });
                                  },
                                  icon: new Icon(LineIcons.edit,
                                      size: 40, color: primary)),
                              new Text(
                                'Editar',
                                style: body1,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Seguro que deseas eliminar ${product.name}'),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.fixed,
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: '¡Eliminar!',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          ctrl.deleteProduct(
                                              productID: product.id!);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: new Icon(LineIcons.trash,
                                    size: 40, color: Colors.red),
                              ),
                              new Text(
                                'Eliminar',
                                style: body1Rojo,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () => showProductDetail(context, product,
                image), //Get.to(ProductDetail(), arguments: product),
            child: Column(
              children: [
                FutureBuilder<Uint8List?>(
                  future: MyStorage().getFilePreview(
                    fileId: product.image![0],
                  ), //works for both public file and private file, for private files you need to be logged in
                  builder: (context, snapshot) {
                    if (snapshot.data != null) image = snapshot.data!;
                    return snapshot.hasData && snapshot.data != null
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: CircleAvatar(
                              backgroundColor: color200,
                              backgroundImage: MemoryImage(
                                snapshot.data!,
                              ),
                              foregroundColor: Colors.white,
                              radius: 35,
                            ))
                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(color500),
                            ),
                          );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text(product.name.toString(),
                    style: subtitulo,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 5,
                ),
                Text(product.description.toString(),
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 5,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.price.toString(),
                        style: body1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center),
                    Icon(LineIcons.dollarSign, color: color500, size: 15)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
