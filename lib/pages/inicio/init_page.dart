import 'package:cotizapack/common/card.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/pages/product/product_category/product_categories_page.dart';
import 'package:cotizapack/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import 'initP_page_ctrl.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitPageCtrl>(
      init: InitPageCtrl(),
      builder: (_ctrl) => Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Header(
              widgetToShow: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),
                    Text(
                      '¡Gestionar!',
                      style: tituloblanco,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "aquí puedes gestionar toda la información de tus cotizaciones",
                      style: body1blanco,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Icon(
                      LineIcons.rocket,
                      color: Colors.white,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
            card(
                function: () => Get.toNamed(Routes.QUOTATIONS),
                icon: LineIcons.fileInvoiceWithUsDollar,
                title: 'Cotizaciones',
                subtitle: 'revisa o genera una nueva cotización'),
            card(
                function: () => Get.toNamed(Routes.CUSTOMERS),
                icon: LineIcons.userPlus,
                title: 'Mis clientes',
                subtitle: 'gestionar mis clientes'),
            card(
                function: () => Get.to(ProductsCategoryPage(),
                    transition: Transition.rightToLeftWithFade),
                icon: LineIcons.conciergeBell,
                title: 'Mis Productos y servicio',
                subtitle: 'gestiona mis categorías, productos y servicios'),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget card(
      {required String title,
      required String subtitle,
      required IconData icon,
      void Function()? function}) {
    return MyCard(
      function: function,
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: subtituloblanco,
            overflow: TextOverflow.visible,
          ),
          SizedBox(
            height: 8,
          ),
          Text(subtitle, style: body1blanco),
        ],
      ),
    );
  }
}
