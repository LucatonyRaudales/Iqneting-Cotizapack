import 'dart:math';

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
  final Random random = new Random();
  final List colors = [
    [Colors.blue.shade400, Colors.blue.shade200],
    [Colors.pink.shade400, Colors.pink.shade200],
    [Colors.green.shade400, Colors.green.shade200],
    [color200, color100],
    [Colors.red.shade400, Colors.red.shade200],
    [Colors.purple.shade400, Colors.purple.shade200],
    [Colors.orange.shade400, Colors.orange.shade200],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Obx(
            () => _buildHeader(ctrl: controller),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Estadísticas - ${DateFormat.yMMMMEEEEd('es_US').format(DateTime.now())}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          controller.obx(
            (statistic) => Column(
              children: [
                Container(
                  // elevation: 6.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
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
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: colors[random.nextInt(colors.length)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTile(
                            color: Colors.transparent,
                            icon: Icons.portrait,
                            title: "Mis cotizaciones",
                            data: "${statistic.totalQuotes}",
                            function: () => Get.toNamed(Routes.QUOTATIONS),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: colors[random.nextInt(colors.length)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTile(
                            color: Colors.transparent,
                            icon: Icons.portrait,
                            title: "Enviados",
                            data: "${statistic.quotesSent}",
                            function: () =>
                                Get.toNamed(Routes.QUOTATIONS, arguments: 1),
                          ),
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
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: colors[random.nextInt(colors.length)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTile(
                            color: Colors.transparent,
                            icon: LineIcons.tags,
                            title: "Categorías",
                            data: "${statistic.myCategories}",
                            function: () => Get.toNamed(Routes.CATEGORY),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: colors[random.nextInt(colors.length)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTile(
                            color: Colors.transparent,
                            icon: LineIcons.list,
                            title: "Productos",
                            data: "${statistic.myProducts}",
                            function: () => Get.toNamed(Routes.PRODUCTSSEARCH),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: colors[random.nextInt(colors.length)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTile(
                            color: Colors.transparent,
                            icon: LineIcons.users,
                            title: "Clientes",
                            data: "${statistic.myClients}",
                            function: () => Get.toNamed(Routes.CUSTOMERS),
                          ),
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
        // color: color500,
        gradient: LinearGradient(
          colors: [
            color700,
            color500,
            color400,
            color300,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              title: Text(
                ctrl.userData.value.businessName!.toUpperCase(),
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
              ctrl.userData.value.ceoName!,
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
}
