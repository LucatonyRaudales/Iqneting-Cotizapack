import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import '../../../common/button.dart';
import '../../../common/textfields.dart';
import '../../../styles/colors.dart';
import '../../../styles/typography.dart';
import 'new_product_ctrl.dart';

class NewProductPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewProductCtrl>(
      init: NewProductCtrl(),
      builder: (_ctrl){
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Agregar producto / servicio', style: subtituloblanco)
          ),
          body: Form(
            key:_formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(children: [
                  InputText(
                    name: 'Nombre',
                    textInputType: TextInputType.name,
                    validator: Validators.nameValidator,
                    prefixIcon: Icon(LineIcons.pen),
                    onChanged: (val)=> _ctrl.product.name = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'descripción',
                    textInputType: TextInputType.name,
                    validator: Validators.nameValidator,
                    prefixIcon: Icon(LineIcons.comment),
                    onChanged: (val)=> _ctrl.product.description = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Precio',
                    textInputType: TextInputType.number,
                    validator: Validators.nameValidator,
                    prefixIcon: Icon(LineIcons.moneyBill),
                    onChanged: (val)=> _ctrl.product.price = double.parse(val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Precio al cliente',
                    textInputType: TextInputType.number,
                    validator: Validators.nameValidator,
                    prefixIcon: Icon(LineIcons.wavyMoneyBill),
                    onChanged: (val)=> _ctrl.product.clientPrice = double.tryParse(val),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  FadeInLeft(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                InkWell(
                                  onTap: ()=> _ctrl.getImage(source: ImageSource.camera),
                                  child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      new Icon(LineIcons.camera, size: 50, color: Colors.purple[700]),
                                      new Text('Cámara', style: body1,)
                                    ],),
                                ),
                                InkWell(
                                  onTap: ()=> _ctrl.getImage(source: ImageSource.gallery),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Icon(LineIcons.image, size: 50, color: Colors.amber[700]),
                                      new Text('Galería', style: body1,)
                                    ],),
                                ),
                              ],),
                            );
                          },
                        );
                        },
                      child: new Container(
                        width: Get.width,
                        height: 200,
                        decoration: BoxDecoration(
                          color: color100,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Center(
                          child://_ctrl.image.path != '' ? 
                          Icon(LineIcons.plusCircle, size: 45, color: Colors.white70,) 
                          //: Image.file(_ctrl.image),
                        )
                      ),
                    ),
                  ),
                      SizedBox(
                        height: 25,
                      ),
                      Button(
                        function: (){
                          if (!_formKey.currentState!.validate()) {
                            return _ctrl.btnController.reset();
                          }
                          _ctrl.saveData();
                        },
                        btnController: _ctrl.btnController,
                        name: 'Registrarme'),
                          SizedBox(height: 30,),
                ],),
              )
            ),
          )
        );
      },
    );
  }
}