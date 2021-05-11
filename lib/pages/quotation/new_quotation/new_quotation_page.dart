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
                child: Obx(()=>viewToShow(ctrl: _ctrl)),
              ),
            ]
          ),
        ),
      ),
        )
      )
    );
  }

Widget viewToShow({required NewQuotationCtrl ctrl}){
  switch (ctrl.activeStep.value) {
    case 0:
      return titleDescription(ctrl: ctrl);
    case 1:
      return _productWidget(ctrl:ctrl);
    case 2:
      return clientDateExpired(ctrl: ctrl);
    case 2:
      return generate(ctrl: ctrl);
    default:
      return Text("Error inesperado");
  }
}

  Widget titleDescription({required NewQuotationCtrl ctrl}){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            InputText(
              name: 'Título',
              validator: Validators.nameValidator,
              autofillHints: [AutofillHints.name],
              textInputType: TextInputType.name,
              prefixIcon: Icon(LineIcons.heading),
              onChanged: (val)=> ctrl.quotation.title = val,
            ),
            SizedBox(
              height: 20,
            ),
            InputText(
              initialValue: ctrl.quotation.description,
              name: 'Descripción',
              validator: Validators.nameValidator,
              autofillHints: [AutofillHints.name],
              textInputType: TextInputType.name,
              prefixIcon: Icon(LineIcons.comment),
              onChanged: (val)=> ctrl.quotation.description = val,  
            ),
            SizedBox(
              height: 25,
            ),
          ]
        ),
    );
  }

  Widget _productWidget({required NewQuotationCtrl ctrl}){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            FadeInUp(
              child:InkWell(
              onTap: ()=> ctrl.showPickerProduct(context),
              child: Container(
                height: 70,
                child:  Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child:  ListTile(
                  trailing: new Icon(Icons.arrow_drop_down),
                  title: new Text(ctrl.quotation.product!.name! == '' ? 'Selecionar producto' : ctrl.quotation.product!.name!, style: subtitulo,  overflow: TextOverflow.ellipsis,),
                  subtitle: new Text('Producto', style: body1, overflow: TextOverflow.ellipsis,),
                  )
                )
              ),
              )
            ),
            ctrl.quotation.product!.name! != '' ? 
            Column(
              children: [
                SizedBox(
                  height: 25,
                ),
            InputText(
              name: 'Cantitdad (opcional)',
              validator: Validators.nameValidator,
              initialValue: 1.toString(),
              autofillHints: [AutofillHints.telephoneNumber],
              textInputType: TextInputType.number,
              prefixIcon: Icon(LineIcons.productHunt),
              onChanged: (val)=> ctrl.quotation.quantity = int.parse(val),  
            ) 
              ],
            ) : SizedBox(),
            SizedBox(
              height: 25,
            ),
            InputText(
              initialValue:ctrl.quotation.product!.price.toString(),
              name: 'Precio',
              validator: Validators.nameValidator,
              autofillHints: [AutofillHints.name],
              textInputType: TextInputType.number,
              prefixIcon: Icon(LineIcons.dollarSign),
              onChanged: (val)=> ctrl.quotation.subTotal = double.parse(val),
            ),
            SizedBox(height:15),

            ElevatedButton(
              child: Row(children: [
                Text('Siguiente', style: subtituloblanco),
                Icon(LineIcons.arrowRight)
              ],
            ),
              onPressed:(){
                if (!_formKey.currentState!.validate()) {
                  return ctrl.btnController.reset();
                }
                ctrl.activeStep++;
              }
            )
          ]
        ),
    );
  }

  Widget clientDateExpired({required NewQuotationCtrl ctrl}){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[                 
              FadeInDown(
                child:InkWell(
                onTap: ()=> DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                  setState(()=> ctrl.quotation.expirationDate = date.millisecondsSinceEpoch);
                }, currentTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1), locale: LocaleType.es),
                child: Container(
                  height: 70,
                  child:  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child:  ListTile(
                    trailing: new Icon(Icons.arrow_drop_down),
                    title: new Text(DateFormat.yMMMMEEEEd('es_US').format(DateTime.fromMillisecondsSinceEpoch(ctrl.quotation.expirationDate!)).toString(), style: subtitulo),
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
                onTap: ()=> ctrl.showPicker(context),
                child: Container(
                  height: 70,
                  child:  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child:  ListTile(
                    trailing: new Icon(Icons.arrow_drop_down),
                    title: new Text(ctrl.customerSelected.name! == '' ? 'Selecionar cliente' : ctrl.customerSelected.name!, style: subtitulo,  overflow: TextOverflow.ellipsis,),
                subtitle: new Text('Cliente', style: body1, overflow: TextOverflow.ellipsis,),
                )
              )
            ),
            )
          ),
            SizedBox(height:15),

            ElevatedButton(
              child: Row(children: [
                Text('Siguiente', style: subtituloblanco),
                Icon(LineIcons.arrowRight)
              ],
            ),
              onPressed:(){
                if (!_formKey.currentState!.validate()) {
                  return ctrl.btnController.reset();
                }
                ctrl.activeStep++;
              }
            )
          ]
        ),
    );
  }

  Widget generate({required NewQuotationCtrl ctrl}){
    return new Column(children: [
      new Text('Ya todo está listo', style: subtitulo),
      SizedBox(height: 20),

      Button(
        function: (){
        if (!_formKey.currentState!.validate()) {
            return ctrl.btnController.reset();
          }
          if(ctrl.customerSelected.id == "" || ctrl.customerSelected.id == null){
            ctrl.btnController.reset();
            return MyAlert.showMyDialog(title: 'Datos vacíos', message: 'Selecciona los datos requeridos para guardar tus datos', color: Colors.red);
          }
            return ctrl.saveData();
        },
        btnController: ctrl.btnController,
        name: 'Generar'),
      SizedBox(height: 12,),
      TextButton(
        child: Text("Cancelar", style: body1,),
        onPressed:()=> Navigator.pop(context),
      ),
      SizedBox(height: 20,),
    ],);
  }
}