import 'package:cotizapack/common/card.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/pages/product/new_product/new_product_page.dart';
import 'package:cotizapack/pages/product/products/products_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../styles/colors.dart';
import '../../styles/typography.dart';

class InitPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
              child: Column(
          children: [
            Header(
              widgetToShow: Column(children: [

            const SizedBox(height: 60.0),
            Text('¡Hola Fulano de tal!', style: tituloblanco,),
            const SizedBox(height: 10.0),
            Text('Actualiza a premium', style: subtituloblanco,),
            const SizedBox(height: 10.0),
            Icon(LineIcons.rocket, color: Colors.white, size: 50,),
              ],),
            ),
            card(
              function:()=> print('crear cotización'),
              icon: LineIcons.fileInvoiceWithUsDollar,
              title: 'Crear cotización',
              subtitle: 'Agrega una nueva cotización'
            ),
            card(
              function:()=> print('crear cliente'),
              icon: LineIcons.userPlus,
              title: 'Crear cliente',
              subtitle: 'Agrega un nuevo cliente para tus cotizaciones'
            ),
            card(
              function:()=> Get.to(ProductsPage(), transition: Transition.rightToLeftWithFade),
              icon: LineIcons.conciergeBell,
              title: 'Productos y servicio',
              subtitle: 'revisa y gestiona tus productos y servicios'
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
    Widget card({required String title, required String subtitle, required IconData icon,  void Function()?function}) {
    return MyCard(
      function: function,
      leading: Icon(icon, color: color700,),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
          title,
            style: subtitulo,
            overflow: TextOverflow.visible,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            subtitle,
              style: body1),
        ],
      ),
    );
  }
}