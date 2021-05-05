import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/model/quotation.dart';
import 'package:cotizapack/pages/quotation/new_quotation/new_quotation_page.dart';
import 'package:cotizapack/pages/quotation/quotations/quotations_ctrl.dart';
import 'package:cotizapack/settings/share.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class QuotationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final spinkit = SpinKitPulse(
        color: color500,
        size: 50.0,
      );
    return GetBuilder<QuotationsCtrl>(
      init: QuotationsCtrl(),
      builder: (_ctrl)=> Scaffold(
        appBar: AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Mis cotizaciones', style: subtituloblanco,),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: color500,
            onPressed: () {
              Get.to(NewQuotationPage(), transition: Transition.rightToLeftWithFade, arguments: {"editData":false, "data": null});
            },
          ),
          body: SafeArea(
            child: _ctrl.haveProducts == false ?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                new Icon(LineIcons.cryingFace, size: 50, color: color500),
                SizedBox(height: 20,),
                Text(
                'No tienes productos o servicios almacenados, presiona (+) para agregar uno nuevo.',
                style: subtitulo,
                textAlign: TextAlign.center,
              ) 
              ])
            ) : 
            (_ctrl.quotationsList.quotations == null || _ctrl.quotationsList.quotations!.isEmpty) ?
            Center(
              child: spinkit 
            ) : RefreshIndicator(
              color: color700,
              onRefresh:_ctrl.getQuotations,
              child:  CustomScrollView(
              slivers:<Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 14.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                        return myCards(quotation: _ctrl.quotationsList.quotations![index], index: index, context:context, ctrl: _ctrl);
                    },
                    childCount: _ctrl.quotationsList.quotations!.length,
                  ),
                )
              ]
            )
          )),
        )
        );
  }

  Widget myCards({required QuotationModel quotation, required int index, required BuildContext context, required QuotationsCtrl ctrl}){
    return FadeInLeft(
      delay: Duration(milliseconds: 200 * index),
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: InkWell(
            onTap: ()async{
              bool canShare =  MyShareClass().canShare(expirationDate: quotation.expirationDate!);
              if(canShare){
                print('Se puede compartir');
              }else{
                print('no se puede compartir');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(quotation.title.toString(), style: subtitulo, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  SizedBox(height: 1,),
                  Text(quotation.description.toString(), style: body1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  SizedBox(height: 15,),
                  quotation.createAt != null ?
                  Text(DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(quotation.createAt!)).toString(), style: body2, overflow: TextOverflow.clip, textAlign: TextAlign.center) : SizedBox(),
                  SizedBox(height: 10,),
                  IconButton(
                    onPressed: (){
                      print('wachar');
                    },
                    icon: Icon(LineIcons.pdfFile, color: Colors.redAccent, size: 30,),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}