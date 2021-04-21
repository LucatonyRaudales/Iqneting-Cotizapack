import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import '../../common/button.dart';
import '../../common/textfields.dart';
import '../../styles/typography.dart';
import 'edit_my_data_ctrl.dart';

class EditMyDataPage extends StatefulWidget {
  @override
  _EditMyDataPageState createState() => _EditMyDataPageState();
}

class _EditMyDataPageState extends State<EditMyDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EditMyDataCtrl>(
        init: EditMyDataCtrl(),
        builder: (_ctrl)=> SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [

              Header(
                height: 300,
                widgetToShow: Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 100),
                  child:FadeInDown(
                    child:new Column(
                      children:[
                        new Icon(LineIcons.userEdit, color: Colors.white,),
                        new Text('Editar mis datos', style: subtituloblanco,),
                        SizedBox(height: 25,),
                        Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundColor: color300,
                  //                backgroundColor: Color(0xff476cfb),
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 140.0,
                                        height: 140.0,
                                        child:  Image.network(
                                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                            fit: BoxFit.fill,
                                          ),
                                      ),),
                                      )
                                ),
                                Align(
                                  alignment: Alignment(1.5,1.5),
                                  child: MaterialButton(
                                    minWidth: 0,
                                    child: Icon(Icons.camera_alt),
                                    onPressed: (){},
                                    textColor: Colors.white,
                                    color: color400,
                                    elevation: 0,
                                    shape: CircleBorder(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]
                    )
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children:[

                  InputText(
                    name: 'Nombre del CEO',
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(LineIcons.userEdit),
                    onChanged: (val)=> print('nombres: $val'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Razón social o nombre del grupo',
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(LineIcons.building),
                    onChanged: (val)=> print('Apellidos: $val'),  
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    name: 'Numero telefónico',
                    textInputType: TextInputType.phone,
                    prefixIcon: Icon(LineIcons.phone),
                    onChanged: (val)=> print('Edad: $val'),  
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    name: 'Dirección',
                    textInputType: TextInputType.streetAddress,
                    prefixIcon: Icon(LineIcons.streetView),
                    onChanged: (val)=> print('Edad: $val'),  
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FadeInUp(
                    child:InkWell(
                    onTap: ()=> _ctrl.showPicker(context),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child:  ListTile(
                        leading: new Icon(LineIcons.tag),
                        title: new Text('Títulom', style: subtitulo,),
                        subtitle: new Text('este es una breve descripcíon del título', style: body1,),
                        )
                      )
                    ),
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