import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/pages/product/product_category/product_categories_ctrl.dart';
import 'package:cotizapack/pages/product/products/products_page.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ProductsCategoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final spinkit = SpinKitPulse(
      color: color500,
      size: 50.0,
    );

    return GetBuilder<ProductCategoriesCtrl>(
      init: ProductCategoriesCtrl(),
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
              _ctrl.showDialog(context);
            },
          ),
          body: SafeArea(
            child: _ctrl.haveCategory == false ?
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
            (_ctrl.productCategoryList.listProductCategory == null || _ctrl.productCategoryList.listProductCategory!.isEmpty) ?
            Center(
              child: spinkit 
            ) : RefreshIndicator(
              color: color700,
              onRefresh:_ctrl.getProductCategories,
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
                        return myCards(category: _ctrl.productCategoryList.listProductCategory![index], index: index, context:context, ctrl: _ctrl);
                    },
                    childCount: _ctrl.productCategoryList.listProductCategory!.length,
                  ),
                )
              ]
            )
          )),
        );
      },
    );
  }

  Widget myCards({required ProductCategory category, required int index, required BuildContext context, required ProductCategoriesCtrl ctrl}){
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child:Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
          onTap: ()=> Get.to(ProductsPage(), arguments: category),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LineIcons.arrowCircleRight, color: color500, size: 30),
                SizedBox(height: 5,),
                Text(category.name.toString(), style: subtitulo, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                SizedBox(height: 5,),
                Text(category.description.toString(), style: body1, textAlign: TextAlign.center),
                SizedBox(height: 5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}