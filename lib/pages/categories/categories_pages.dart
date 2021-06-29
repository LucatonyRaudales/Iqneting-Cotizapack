import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/modalBottomSheet.dart';
import 'package:cotizapack/model/user_data.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import 'categories_ctrl.dart';

class CategoriesPage extends GetView<CategoriesCtrl> {
  void showProductDetail(BuildContext context, UserData user, Uint8List image) {
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
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                ),
                image: user.logo != ''
                    ? DecorationImage(
                        image: MemoryImage(
                          image,
                        ),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage(
                          'assets/images/logo_colors.png',
                        ),
                        fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new Text(user.businessName!, style: subtitulo),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(user.category.name, style: body1),
                ],
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: Icon(LineIcons.locationArrow, color: color500),
                      title: new Text('Descripción', style: body1),
                      subtitle: new Text('Descripción de la categoría',
                          style: body2)),
                ],
              )),
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
                    color: color500, borderRadius: BorderRadius.circular(30)),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: RefreshIndicator(
          color: color700,
          onRefresh: controller.loadData,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                //backgroundColor: Colors.white,
                backgroundColor: Colors.grey.shade200,
                pinned: false,
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: Header(
                  widgetToShow: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(height: 10.0),
                      ),
                      Expanded(
                        child: Text(
                          'Negocios',
                          style: tituloblanco,
                        ),
                      ),
                      Expanded(child: SizedBox(height: 10.0)),
                      Expanded(
                        child: Icon(
                          LineIcons.tags,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 200,
              ),
              SliverAppBar(
                backgroundColor: Colors.grey.shade200,
                pinned: true,
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 200,
                  width: Get.width,
                  child: new Swiper(
                    controller: controller.newController(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Image(
                          image: MemoryImage(
                            controller.bannersImges[index],
                          ),
                        ),
                      );
                    },
                    itemCount: controller.bannersImges.length,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    autoplay: true,
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
                expandedHeight: 200,
              ),
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 14.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return myCards(
                          user: controller.userList.users![index],
                          index: index,
                          context: context,
                          ctrl: controller);
                    },
                    childCount: controller.userList.users == null
                        ? 0
                        : controller.userList.users!.length,
                  ),
                ),
              ),
              // SliverGrid(
              //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 200,
              //     mainAxisSpacing: 14.0,
              //     crossAxisSpacing: 1.0,
              //     childAspectRatio: 1.0,
              //   ),
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext context, int index) {
              //       return myCards(
              //           user: _ctrl.userList.users![index],
              //           index: index,
              //           context: context,
              //           ctrl: _ctrl);
              //     },
              //     childCount: _ctrl.userList.users == null
              //         ? 0
              //         : _ctrl.userList.users!.length,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget myCards(
      {required UserData user,
      required int index,
      required BuildContext context,
      required CategoriesCtrl ctrl}) {
    Uint8List image = Uint8List(0);
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        shadowColor: color500,
        elevation: 2,
        child: InkWell(
          onTap: () => showProductDetail(context, user,
              image), //Get.to(ProductDetail(), arguments: product),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              user.logo != ''
                  ? FutureBuilder<Uint8List?>(
                      future: MyStorage().getFilePreview(
                        fileId: user.logo!,
                      ), //works for both public file and private file, for private files you need to be logged in
                      builder: (context, snapshot) {
                        if (snapshot.data != null) image = snapshot.data!;
                        return snapshot.hasData && snapshot.data != null
                            ? CircleAvatar(
                                backgroundColor: color200,
                                backgroundImage: MemoryImage(
                                  snapshot.data!,
                                ),
                                foregroundColor: Colors.white,
                                radius: 35,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      color500),
                                ),
                              );
                      },
                    )
                  : CircleAvatar(
                      backgroundColor: color200,
                      backgroundImage:
                          AssetImage('assets/images/logo_colors.png'),
                      foregroundColor: Colors.white,
                      radius: 35,
                    ),
              SizedBox(
                height: 5,
              ),
              Text(user.businessName.toString(),
                  style: subtitulo,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
              SizedBox(
                height: 5,
              ),
              Text(user.address.toString(),
                  style: body1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
              SizedBox(
                height: 5,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user.category.name.toString(),
                      style: body1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center),
                  Icon(LineIcons.appNet, color: color500, size: 15)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
