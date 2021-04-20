import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cotizapack/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../styles/colors.dart';
import 'categories/categories_pages.dart';
import 'inicio/init_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            InitPage(),
            CategoriesPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        showElevation: false,
        backgroundColor: color500,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Text('Inicio'),
            icon: Icon(LineIcons.home)
          ),
          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Text('Negocios'),
            icon: Icon(LineIcons.rocket)
          ),
          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Text('Perfil'),
            icon: Icon(LineIcons.userAlt)
          ),
        ],
      ),
    );
  }
}
