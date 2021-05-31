import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/validators.dart';
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EditMyDataCtrl>(
        init: EditMyDataCtrl(),
        builder: (_ctrl) => Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Header(
                  height: 300,
                  widgetToShow: Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 100),
                    child: FadeInDown(
                      child: new Column(
                        children: [
                          new Icon(
                            LineIcons.userEdit,
                            color: Colors.white,
                          ),
                          new Text(
                            'Editar mis datos',
                            style: subtituloblanco,
                          ),
                          SizedBox(
                            height: 25,
                          ),
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
                                      backgroundColor: color400,
                                      //        ghj       backgroundColor: Color(0xff476cfb),
                                      child: Image.asset(
                                        "assets/images/logo_white.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    InputText(
                      initialValue: _ctrl.userData!.rfc,
                      name: 'RFC',
                      validator: Validators.nameValidator,
                      autofillHints: [AutofillHints.name],
                      textInputType: TextInputType.name,
                      prefixIcon: Icon(LineIcons.identificationBadge),
                      onChanged: (val) => _ctrl.userData!.rfc = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      initialValue: _ctrl.userData!.ceoName,
                      name: 'Nombre del CEO',
                      validator: Validators.nameValidator,
                      autofillHints: [AutofillHints.name],
                      textInputType: TextInputType.name,
                      prefixIcon: Icon(LineIcons.userEdit),
                      onChanged: (val) => _ctrl.userData!.ceoName = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      initialValue: _ctrl.userData!.businessName,
                      name: 'Razón social o nombre del grupo',
                      validator: Validators.nameValidator,
                      autofillHints: [AutofillHints.name],
                      textInputType: TextInputType.name,
                      prefixIcon: Icon(LineIcons.building),
                      onChanged: (val) => _ctrl.userData!.businessName = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    InputText(
                      name: 'Número telefónico',
                      initialValue: _ctrl.userData!.phone,
                      validator: Validators.phoneValidator,
                      autofillHints: [AutofillHints.telephoneNumber],
                      textInputType: TextInputType.phone,
                      prefixIcon: Icon(LineIcons.phone),
                      onChanged: (val) => _ctrl.userData!.phone = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    FadeInUp(
                        child: InkWell(
                      onTap: () => print(
                          'get address'), //_ctrl.getAddress(context:context),
                      child: Container(
                          height: 70,
                          child: Material(
                              elevation: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: ListTile(
                                trailing: new Icon(Icons.arrow_drop_down),
                                title: new Text(
                                    _ctrl.userData!.address == null ||
                                            _ctrl.userData!.address! == ''
                                        ? 'Agregar dirección'
                                        : _ctrl.userData!.address!,
                                    style: subtitulo),
                                subtitle: new Text(
                                  'Dirección',
                                  style: body1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))),
                    )),
                    SizedBox(
                      height: 25,
                    ),
                    InputText(
                      name: 'Link de pago',
                      initialValue: _ctrl.userData!.paymentUrl,
                      validator: Validators.urlValidator,
                      autofillHints: [AutofillHints.addressCity],
                      textInputType: TextInputType.url,
                      prefixIcon: Icon(LineIcons.paypal),
                      onChanged: (val) => _ctrl.userData!.paymentUrl = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    FadeInUp(
                        child: InkWell(
                      onTap: () => _ctrl.showPicker(context),
                      child: Container(
                          height: 70,
                          child: Material(
                              elevation: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: ListTile(
                                trailing: new Icon(Icons.arrow_drop_down),
                                title: new Text(_ctrl.userData!.category.name,
                                    style: subtitulo),
                                subtitle: new Text(
                                  _ctrl.userData!.category.description,
                                  style: body1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))),
                    )),
                    SizedBox(
                      height: 25,
                    ),
                    Button(
                        function: () {
                          if (!_formKey.currentState!.validate()) {
                            return _ctrl.btnController.reset();
                          }
                          if (_ctrl.userData!.category.id == "" ||
                              _ctrl.userData?.category.id == null) {
                            _ctrl.btnController.reset();
                            return MyAlert.showMyDialog(
                                title: 'Datos vacíos',
                                message:
                                    'elige una categoría para guardar tus datos',
                                color: Colors.red);
                          }
                          if (_ctrl.userData!.address == null ||
                              _ctrl.userData!.address! == '') {
                            _ctrl.btnController.reset();
                            return MyAlert.showMyDialog(
                                title: 'Datos vacíos',
                                message:
                                    'ofrécenos tu dirección para guardar tus datos',
                                color: Colors.red);
                          }
                          if (_ctrl.isUpdate) {
                            return _ctrl.updateMyData();
                          }
                          return _ctrl.saveMyData();
                        },
                        btnController: _ctrl.btnController,
                        name: 'Guardar'),
                  ]),
                ),
                SizedBox(
                  height: 12,
                ),
                TextButton(
                    child: Text(
                      "Cancelar",
                      style: body1,
                    ),
                    onPressed: () {
                      if (_ctrl.isUpdate) {
                        return Navigator.pop(context);
                      }
                      return _ctrl.logout();
                    }),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
