import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';

import '../../common/button.dart';
import '../../common/textfields.dart';
import '../../styles/typography.dart';
import '../../styles/typography.dart';
import 'edit_my_data_ctrl.dart';

class EditMyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EditMyDataCtrl>(
        init: EditMyDataCtrl(),
        builder: (_ctrl)=> SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [

              Header(
                height: 180,
                widgetToShow: Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 100),
                  child:FadeInDown(
                    child:new Column(
                      children:[
                        new Icon(LineIcons.userEdit, color: Colors.white,),
                        new Text('Editar mis datos', style: subtituloblanco,)
                      ]
                    )
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children:[

                  InputText(
                    name: 'Nombres',
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(LineIcons.userEdit),
                    onChanged: (val)=> print('nombres: $val'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Apellidos',
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(LineIcons.userEdit),
                    onChanged: (val)=> print('Apellidos: $val'),  
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    name: 'Edad',
                    textInputType: TextInputType.number,
                    prefixIcon: Icon(LineIcons.userEdit),
                    onChanged: (val)=> print('Edad: $val'),  
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Button(
                    function: _ctrl.editMyData,
                    btnController: _ctrl.btnController,
                    name: 'Guardar'),
                ]),
              ),
              SizedBox(height: 20,),
            ],)
          ),
        ),
      ),
    );
  }
}