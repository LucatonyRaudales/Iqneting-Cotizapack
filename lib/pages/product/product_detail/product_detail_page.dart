import 'package:cotizapack/pages/product/product_detail/product_detail_ctrl.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailCtrl>(
      init: ProductDetailCtrl(),
      builder: (_ctrl)=> Scaffold(
        appBar: AppBar(
          backgroundColor: color500,
          centerTitle: true,
          title: new Text(_ctrl.product.name!, style: subtituloblanco,),
        ),
      ),
    );
  }
}