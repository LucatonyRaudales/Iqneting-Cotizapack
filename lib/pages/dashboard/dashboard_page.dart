import 'package:cotizapack/routes/app_pages.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'dashboard_ctrl.dart';

class DashboardPage extends GetView<DashboardCtrl> {
  final TextStyle whiteText = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GetBuilder<DashboardCtrl>(
      builder: (_ctrl) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildHeader(ctrl: _ctrl),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Estadísticas - ${DateFormat.yMMMMEEEEd('es_US').format(DateTime.now())}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            _ctrl.obx(
              (statistic) => Column(
                children: [
                  Card(
                    elevation: 4.0,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.bottomCenter,
                              width: 45.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: 8.0,
                                    color: Colors.green.shade100,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    height: 25,
                                    width: 8.0,
                                    color: Colors.green.shade300,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    height: 40,
                                    width: 8.0,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              "Aceptados",
                              style: body1,
                            ),
                            subtitle: Text(
                              '${statistic!.quotesSent}',
                              style: subtituloVerde,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.bottomCenter,
                              width: 45.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: 8.0,
                                    color: Colors.red.shade100,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    height: 25,
                                    width: 8.0,
                                    color: Colors.red.shade300,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Container(
                                    height: 40,
                                    width: 8.0,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              "Cancelados",
                              style: body1,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              '${statistic.quotesCanceled}',
                              style: subtituloRojo,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: _buildTile(
                            color: Colors.pink,
                            icon: Icons.portrait,
                            title: "Mis cotizaciones",
                            data: "${statistic.totalQuotes}",
                            function: () => Get.toNamed(Routes.QUOTATIONS),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _buildTile(
                            color: Colors.green,
                            icon: Icons.portrait,
                            title: "Enviados",
                            data: "${statistic.quotesSent}",
                            function: () =>
                                Get.toNamed(Routes.QUOTATIONS, arguments: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildTile(
                            color: Colors.blue,
                            icon: LineIcons.tags,
                            title: "Categorías",
                            data: "${statistic.myCategories}",
                            function: () => Get.toNamed(Routes.CATEGORY),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _buildTile(
                            color: Colors.pink,
                            icon: LineIcons.list,
                            title: "Productos",
                            data: "${statistic.myProducts}",
                            function: () => Get.toNamed(Routes.PRODUCTSSEARCH),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _buildTile(
                            color: Colors.blue,
                            icon: LineIcons.users,
                            title: "Clientes",
                            data: "${statistic.myClients}",
                            function: () => Get.toNamed(Routes.CUSTOMERS),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
              onLoading: Center(
                child: SpinKitPulse(
                  color: color500,
                  size: 50.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildHeader({required DashboardCtrl ctrl}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: color500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              title: Text(
                ctrl.userData.businessName!.toUpperCase(),
                style: tituloblanco,
              ),
              trailing: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      ctrl.refreshStatistics();
                      Get.snackbar(
                        '',
                        '',
                        titleText: Text('Actualizando estadísticas',
                            style: subtituloblanco),
                        backgroundColor: color400.withOpacity(0.4),
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    icon: Icon(Icons.refresh_outlined, color: Colors.white),
                  )) /*CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fichef.bbci.co.uk%2Fnews%2F1024%2Fmedia%2Fimages%2F71695000%2Fjpg%2F_71695702_020225302-1.jpg&f=1&nofb=1'),
            ),*/
              ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              ctrl.userData.ceoName!,
              style: subtituloblanco,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Bienvenido, que disfrutes de tu día",
              style: whiteText,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildTile(
      {required Color color,
      required IconData icon,
      required String title,
      required String data,
      Function()? function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              title,
              style: whiteText.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              data,
              style: whiteText.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
