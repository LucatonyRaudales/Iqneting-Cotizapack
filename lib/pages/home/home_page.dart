import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cotizapack/pages/categories/categories_pages.dart';
import 'package:cotizapack/pages/dashboard/dashboard_page.dart';
import 'package:cotizapack/pages/inicio/init_page.dart';
import 'package:cotizapack/pages/profile/profile_page.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: SizedBox.expand(
            child: PageView(
              controller: _.pageController,
              onPageChanged: (index) {
                _.currentIndex.value = index;
              },
              children: <Widget>[
                DashboardPage(),
                InitPage(),
                CategoriesPage(),
                ProfilePage(),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavyBar(
              selectedIndex: _.currentIndex.value,
              onItemSelected: (index) {
                _.currentIndex.value = index;
                _.pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
              showElevation: false,
              backgroundColor: color700,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  activeColor: Colors.white,
                  title: Text('Dashboard'),
                  icon: Icon(LineIcons.pieChart),
                ),
                BottomNavyBarItem(
                  activeColor: Colors.white,
                  title: Text('Inicio'),
                  icon: Icon(LineIcons.home),
                ),
                BottomNavyBarItem(
                  activeColor: Colors.white,
                  title: Text('Negocios'),
                  icon: Icon(LineIcons.rocket),
                ),
                BottomNavyBarItem(
                  activeColor: Colors.white,
                  title: Text('Perfil'),
                  icon: Icon(LineIcons.userAlt),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
