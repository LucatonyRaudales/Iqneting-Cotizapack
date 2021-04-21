import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/model/product.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/product_detail/product_detail_page.dart';
import 'package:cotizapack/pages/product/products/products_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:line_icons/line_icons.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../styles/colors.dart';
import '../../../styles/typography.dart';

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
            title: new Text('Mis productos y servicios', style: subtituloblanco,),
          ),
          floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: color500,
        onPressed: () {
          Get.to(NewProductPage(), transition: Transition.rightToLeftWithFade);
        },
      ),
          body: SafeArea(
            child: (_ctrl.productList.products == null || _ctrl.productList.products!.isEmpty) ?
            Center(
              child: spinkit 
            ) : ListView.builder(
              itemCount:  _ctrl.productList.products!.length,
              itemBuilder: (context, index){
                return myCards(product: _ctrl.productList.products![index], index: index);
              })),
        );
      },
    );
  }

  Widget myCards({required ProductModel product, required int index}){
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
          onTap: ()=> Get.to(ProductDetail(), arguments: product),
                      child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color200,
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.fill,
                  placeholder: kTransparentImage,
                  image: 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fimg.bleacherreport.net%2Fimg%2Fimages%2Fphotos%2F002%2F197%2F187%2Frey_mysterio_wallpaper_by_regioart2012-d4xo2r3_crop_exact.jpg%3Fw%3D1200%26h%3D1200%26q%3D75&f=1&nofb=1',
                  ),
                foregroundColor: Colors.white,
              ),
              title: Text(product.name.toString(), style: subtitulo, overflow: TextOverflow.ellipsis),
              subtitle: Text(product.description.toString(), style: body1, overflow: TextOverflow.ellipsis,),
              trailing: new Icon(Icons.arrow_forward_ios, size: 15),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: color500,
          icon: LineIcons.edit,
          onTap: () => print('rarchive'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Eliminar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('Delete'),
        ),
      ],
    )
    );
  }
}