import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import 'categories_ctrl.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Future<void> loadData() async {
    print('loadData');
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CategoriesCtrl(),
      builder:(_ctrl){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: color500,
            title: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(LineIcons.appNet),
              new Text('Categories', style: subtituloblanco,)
            ],),
          ),
            body:SafeArea(
              child: RefreshIndicator(
                  color: color700,
                  onRefresh:loadData,
                  child: SingleChildScrollView(
                    child:  Column(children: [
                    SizedBox(height:5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 200,
                      width: Get.width,
                      child: new Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),child: Image.network(
                            "http://via.placeholder.com/288x188",
                            fit: BoxFit.cover,
                          )
                        );
                        },
                      itemCount: 10,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      autoplay: true,
                      ),
                    ),
                    GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(1.5),
                      crossAxisCount: 2,
                      childAspectRatio: 0.80,
                      mainAxisSpacing: 0.2,
                      crossAxisSpacing: .2,
                      children: [
                        card(
                            title: 'Crear cotización',
                          ),
                          card(
                            title: 'Crear cliente',
                          ),
                          card(
                            title: 'Agregar servicio',
                          ), card(
                            title: 'Crear cotización',
                          ),
                          card(
                            title: 'Crear cliente',
                          ),
                          card(
                            title: 'Agregar servicio',
                          ),
                      ],
                      shrinkWrap: true,
                    )
                ],), 
              ),
            ),
          )
        );
      });
  }
  Widget card({required String title}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
            colors: [color200, color100]),
      ),
      width: double.infinity,
      height: 10,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(
        child: Text(title, style: subtitulo, overflow: TextOverflow.ellipsis, ),
      )
    );
  }
}