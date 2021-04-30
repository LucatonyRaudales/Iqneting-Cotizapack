import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/products/products_ctrl.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final spinkit = SpinKitPulse(
  color: color500,
  size: 50.0,
);
    return GetBuilder<ProductsCtrl>(
      init: ProductsCtrl(),
      builder: (_ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Mis categorías de productos', style: subtituloblanco,),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: color500,
            onPressed: () {
              Get.to(NewProductPage(), transition: Transition.rightToLeftWithFade, arguments: {"editData":false, "data": null});
            },
          ),
          body: SafeArea(
            child: _ctrl.haveProducts == false ?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                new Icon(LineIcons.hushedFace, size: 50, color: color500),
                SizedBox(height: 20,),
                Text(
                'No tienes categorías guardadas, presiona (+) para agregar uno nuevo.',
                style: subtitulo,
                textAlign: TextAlign.center,
              ) 
              ])
            ) : 
            (_ctrl.productList.products == null || _ctrl.productList.products!.isEmpty) ?
            Center(
              child: spinkit 
            ) : RefreshIndicator(
              color: color700,
              onRefresh:_ctrl.getProducts,
              child:  CustomScrollView(
              slivers:<Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 14.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                        return myCards(product: _ctrl.productList.products![index], index: index, context:context, ctrl: _ctrl);
                    },
                    childCount: _ctrl.productList.products!.length,
                  ),
                )
              ]
            )
          )),
        );
      },
    );
  }

  Widget myCards({required ProductCategory category, required int index, required BuildContext context, required ProductsCtrl ctrl}){
    Uint8List image = Uint8List(0);
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Card(
          color: color50,
          elevation: 4,
          child: InkWell(
          onTap: ()=> Get.to(ProductsPage(), arguments: category),
            child: Column(
              children: [
                FutureBuilder<Uint8List>(
                  future: MyStorage().getFilePreview(
                    fileId: product.image![0],
                  ), //works for both public file and private file, for private files you need to be logged in
                  builder: (context, snapshot) {
                    if(snapshot.data != null) image = snapshot.data!;
                    return snapshot.hasData && snapshot.data != null
                      ? Container(
                        padding: EdgeInsets.symmetric(vertical:5),
                        child: CircleAvatar(
                        backgroundColor: color200,
                        backgroundImage: MemoryImage(
                          snapshot.data!,
                        ),
                        foregroundColor: Colors.white,
                        radius: 35,
                      )
                      )
                      : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: new AlwaysStoppedAnimation<Color>(color500),);
                  },
                ),
                SizedBox(height: 5,),
                Text(product.name.toString(), style: subtitulo, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                SizedBox(height: 5,),
                Text(product.description.toString(), style: body1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                SizedBox(height: 5,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(product.price.toString(), style: body1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  Icon(LineIcons.dollarSign, color: color500, size: 15)
                ],)
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          color: color500,
          icon: LineIcons.edit,
          onTap: () => Get.to(NewProductPage(), transition: Transition.rightToLeftWithFade, arguments: {"editData":true, "data": product}),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => ctrl.deleteProduct(productID: product.id!),
        ),
      ],
    )
    );
  }
}