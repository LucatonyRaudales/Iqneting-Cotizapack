import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'new_quotation_ctrl.dart';

class NewQuotationPage extends StatefulWidget {
  @override
  _NewQuotationPageState createState() => _NewQuotationPageState();
}

class _NewQuotationPageState extends State<NewQuotationPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          body: GetBuilder<NewQuotationCtrl>(
            init: NewQuotationCtrl(),
            builder: (_ctrl)=> Form(
              key: _formKey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Header(
                      height: 260,
                      widgetToShow: Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 100),
                        child:FadeInDown(
                          child:new Column(
                            children:[
                              SizedBox(height: 15,),
                              Icon(LineIcons.swatchbook, color: Colors.white, size: 49),
                              SizedBox(height: 25,),
                              new Text('Crear cotización', style: subtituloblanco,),
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
                          name: 'Título',
                          validator: Validators.nameValidator,
                          autofillHints: [AutofillHints.name],
                          textInputType: TextInputType.name,
                          prefixIcon: Icon(LineIcons.heading),
                          onChanged: (val)=> _ctrl.quotation.title = val,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InputText(
                          initialValue: _ctrl.quotation.description,
                          name: 'Descripción',
                          validator: Validators.nameValidator,
                          autofillHints: [AutofillHints.name],
                          textInputType: TextInputType.name,
                          prefixIcon: Icon(LineIcons.comment),
                          onChanged: (val)=> _ctrl.quotation.description = val,  
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        InputText(
                          initialValue:'0.00',
                          name: 'Precio',
                          validator: Validators.nameValidator,
                          autofillHints: [AutofillHints.name],
                          textInputType: TextInputType.number,
                          prefixIcon: Icon(LineIcons.dollarSign),
                          onChanged: (val)=> _ctrl.quotation.subTotal = double.parse(val),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        FadeInDown(
                          child:InkWell(
                          onTap: ()=> DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2030, 7, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(()=> _ctrl.quotation.expirationDate = date.millisecondsSinceEpoch);
                          }, currentTime: DateTime.now(), locale: LocaleType.es),
                          child: Container(
                            height: 70,
                            child:  Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child:  ListTile(
                              trailing: new Icon(Icons.arrow_drop_down),
                              title: new Text(DateFormat.yMMMMEEEEd(Get.locale).format(DateTime.fromMillisecondsSinceEpoch(_ctrl.quotation.expirationDate!)).toString(), style: subtitulo),
                          subtitle: new Text('Fecha de expiración', style: body1, overflow: TextOverflow.ellipsis,),
                          )
                        )
                      ),
                      )
                    ),
                        SizedBox(
                          height: 25,
                        ),
                        FadeInUp(
                          child:InkWell(
                          onTap: ()=> _ctrl.showPicker(context),
                          child: Container(
                            height: 70,
                            child:  Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child:  ListTile(
                              trailing: new Icon(Icons.arrow_drop_down),
                              title: new Text(_ctrl.customerSelected.name! == '' ? 'Selecionar cliente' : _ctrl.customerSelected.name!, style: subtitulo,  overflow: TextOverflow.ellipsis,),
                          subtitle: new Text('Cliente', style: body1, overflow: TextOverflow.ellipsis,),
                          )
                        )
                      ),
                      )
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    FadeInUp(
                      child:InkWell(
                      onTap: ()=> _ctrl.showPickerProduct(context),
                      child: Container(
                        height: 70,
                        child:  Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:  ListTile(
                          trailing: new Icon(Icons.arrow_drop_down),
                          title: new Text(_ctrl.quotation.product!.name! == '' ? 'Selecionar producto' : _ctrl.quotation.product!.name!, style: subtitulo,  overflow: TextOverflow.ellipsis,),
                          subtitle: new Text('Producto', style: body1, overflow: TextOverflow.ellipsis,),
                          )
                        )
                      ),
                      )
                    ),
                    _ctrl.quotation.product!.name! != '' ? 
                    Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                    InputText(
                      name: 'Cantitdad',
                      validator: Validators.nameValidator,
                      autofillHints: [AutofillHints.telephoneNumber],
                      textInputType: TextInputType.number,
                      prefixIcon: Icon(LineIcons.productHunt),
                      onChanged: (val)=> _ctrl.quotation.quantity = int.parse(val),  
                    ) 
                      ],
                    ) : SizedBox(),
                    SizedBox(
                      height: 25,
                    ),
                    Button(
                      function: (){
                      if (!_formKey.currentState!.validate()) {
                          return _ctrl.btnController.reset();
                        }
                        if(_ctrl.customerSelected.id == "" || _ctrl.customerSelected.id == null){
                          _ctrl.btnController.reset();
                          return MyAlert.showMyDialog(title: 'Datos vacíos', message: 'Selecciona los datos requeridos para guardar tus datos', color: Colors.red);
                        }
                          return _ctrl.saveData();
                      },
                      btnController: _ctrl.btnController,
                      name: 'Generar'),
                  ]),
                ),
                SizedBox(height: 12,),
                TextButton(
                  child: Text("Cancelar", style: body1,),
                  onPressed:()=> Navigator.pop(context),
                ),
                SizedBox(height: 20,),
              ],)
            ),
          ),
        ),
      ),
    );
  }
}