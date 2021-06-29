import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/pages/customer/customers/customers_ctrl.dart';
import 'package:cotizapack/pages/customer/new_customers/new_customer_page.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../../styles/colors.dart';
import '../../../styles/typography.dart';

class CustomerPage extends StatelessWidget {
  void showProductDetail(
      BuildContext context, CustomerModel customer, Uint8List image) {
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
                      fit: BoxFit.cover)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(customer.name!, style: subtitulo),
                SizedBox(
                  height: 10,
                ),
                new Text(customer.notes!, style: body1),
                ListTile(
                    leading: Icon(LineIcons.envelope, color: color500),
                    title: new Text(customer.email!, style: body1),
                    subtitle: new Text('Correo electrónico', style: body2)),
                ListTile(
                    leading: Icon(LineIcons.phone, color: color500),
                    title: new Text(customer.phone!, style: body1),
                    subtitle: new Text('Teléfono', style: body2)),
                ListTile(
                    leading: Icon(LineIcons.locationArrow, color: color500),
                    title: new Text(customer.address!, style: body1),
                    subtitle: new Text('Dirección', style: body2)),
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
                          color: color500,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          "Atrás",
                          style: subtituloblanco,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitPulse(
      color: color500,
      size: 50.0,
    );
    return GetBuilder<CustomersCtrl>(
      init: CustomersCtrl(),
      builder: (_ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text(
              'Mis clientes',
              style: subtituloblanco,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: color500,
            onPressed: () {
              Get.to(
                () => NewCustomerPage(),
                transition: Transition.rightToLeftWithFade,
                arguments: {"editData": false, "data": null},
              );
            },
          ),
          body: SafeArea(
            child: _ctrl.haveProducts == false
                ? Center(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        new Icon(LineIcons.hushedFace,
                            size: 50, color: color500),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No hay clientes para mostrar',
                          style: subtitulo,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          child: Text(
                            "Intentar de nuevo?",
                            style: body1,
                          ),
                          onPressed: () => _ctrl.getCustomers(),
                        ),
                      ]))
                : (_ctrl.customerList.customers == null ||
                        _ctrl.customerList.customers!.isEmpty)
                    ? Center(child: spinkit)
                    : RefreshIndicator(
                        color: color700,
                        onRefresh: _ctrl.getCustomers,
                        child: CustomScrollView(
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
                                  return myCards(
                                      customer:
                                          _ctrl.customerList.customers![index],
                                      index: index,
                                      context: context,
                                      ctrl: _ctrl);
                                },
                                childCount:
                                    _ctrl.customerList.customers!.length,
                              ),
                            )
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }

  Widget myCards(
      {required CustomerModel customer,
      required int index,
      required BuildContext context,
      required CustomersCtrl ctrl}) {
    Uint8List image = Uint8List(0);
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          color: Colors.white,
          elevation: 4,
          child: InkWell(
            onTap: () => showProductDetail(context, customer,
                image), //Get.to(ProductDetail(), arguments: product),
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
                      new Text(customer.name!, style: subtitulo),
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
                                    Get.to(NewCustomerPage(),
                                            transition:
                                                Transition.rightToLeftWithFade,
                                            arguments: {
                                          "editData": true,
                                          "data": customer
                                        })!
                                        .then((_) {
                                      print('holas');
                                      ctrl.getCustomers();
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
                                            'Seguro que deseas eliminar ${customer.name}'),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.fixed,
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                            label: '¡Eliminar!',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              ctrl.deleteCustomer(
                                                  customerID: customer.id!);
                                            }),
                                      ),
                                    );
                                  },
                                  icon: new Icon(LineIcons.trash,
                                      size: 40, color: Colors.red)),
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
            child: Column(
              children: [
                FutureBuilder<Uint8List?>(
                  future: MyStorage().getFilePreview(
                    fileId: customer.image!,
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
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(color500),
                          );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text(customer.name.toString(),
                    style: subtitulo,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 5,
                ),
                Text(customer.notes.toString(),
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 5,
                ),
                Text(customer.email.toString(),
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                Icon(LineIcons.envelope, color: color500, size: 15)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
