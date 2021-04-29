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
import 'new_customers_ctrl.dart';

class NewCustomerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewCustomerCtrl>(
      init: NewCustomerCtrl(),
      builder: (_ctrl){
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: color500,
            centerTitle: true,
            title: new Text('Agregar cliente', style: subtituloblanco)
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
                    onChanged: (val)=> _ctrl.customer.name = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Correo electrónico',
                    textInputType: TextInputType.emailAddress,
                    validator: Validators.emailValidator,
                    prefixIcon: Icon(LineIcons.envelope),
                    onChanged: (val)=> _ctrl.customer.email = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Nota',
                    textInputType: TextInputType.name,
                    validator: Validators.nameValidator,
                    prefixIcon: Icon(LineIcons.comment),
                    onChanged: (val)=> _ctrl.customer.notes = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputText(
                    name: 'Teléfono',
                    textInputType: TextInputType.phone,
                    validator: Validators.phoneValidator,
                    prefixIcon: Icon(LineIcons.phone),
                    onChanged: (val)=> _ctrl.customer.phone = val,
                  ),
                  SizedBox(
                    height: 20,
                  ),/*
                  InputText(
                    name: 'Dirección',
                    textInputType: TextInputType.streetAddress,
                    validator: Validators.addressValidator,
                    prefixIcon: Icon(LineIcons.mapMarked),
                    onChanged: (val)=> _ctrl.customer.address = val,
                  ),
                  */
                  FadeInUp(
                      child:InkWell(
                      onTap: ()=>_ctrl.getAddress(context:context),
                      child: Container(
                        height: 70,
                        child:  Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:  ListTile(
                          trailing: new Icon(Icons.arrow_drop_down),
                          title: new Text(_ctrl.customer.address! == '' ? 'Agregar dirección' : _ctrl.customer.address!, style: subtitulo),
                          subtitle: new Text('Dirección', style: body1, overflow: TextOverflow.ellipsis,),
                          )
                        )
                      ),
                      )
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeInLeft(
                    child: InkWell(
                      onTap: ()=>_ctrl.getImage(),
                      child: new Container(
                        width: Get.width,
                        height: 200,
                        decoration: BoxDecoration(
                          color: color100,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Center(
                          child:_ctrl.image.path == '' ? 
                          Icon(LineIcons.plusCircle, size: 45, color: Colors.white70,) 
                          : Image.file(_ctrl.image),
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
                        name: 'Guardar'),
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