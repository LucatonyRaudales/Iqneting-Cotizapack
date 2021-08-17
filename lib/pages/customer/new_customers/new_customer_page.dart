import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
      builder: (_ctrl) {
        return Scaffold(
            appBar: new AppBar(
                backgroundColor: color500,
                centerTitle: true,
                title: new Text('Agregar cliente', style: subtituloblanco)),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  children: [
                    InputText(
                      name: 'RFC',
                      initialValue: _ctrl.customer.rfc,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.pen),
                      onChanged: (val) => _ctrl.customer.rfc = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Nombre',
                      initialValue: _ctrl.customer.name,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.pen),
                      onChanged: (val) => _ctrl.customer.name = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Correo electrónico',
                      initialValue: _ctrl.customer.email,
                      textInputType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                      prefixIcon: Icon(LineIcons.envelope),
                      onChanged: (val) => _ctrl.customer.email = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Nota',
                      initialValue: _ctrl.customer.notes,
                      minLines: 4,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.comment),
                      onChanged: (val) => _ctrl.customer.notes = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Teléfono',
                      initialValue: _ctrl.customer.phone,
                      textInputType: TextInputType.phone,
                      validator: Validators.phoneValidator,
                      prefixIcon: Icon(LineIcons.phone),
                      onChanged: (val) => _ctrl.customer.phone = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*
                  InputText(
                    name: 'Dirección',
                    textInputType: TextInputType.streetAddress,
                    validator: Validators.addressValidator,
                    prefixIcon: Icon(LineIcons.mapMarked),
                    onChanged: (val)=> _ctrl.customer.address = val,
                  ),
                  */
                    FadeInUp(
                      child: InkWell(
                        onTap: () => _ctrl.getAddress(context: context),
                        child: Container(
                          height: 70,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: ListTile(
                              trailing: new Icon(Icons.arrow_drop_down),
                              title: new Text(
                                  _ctrl.customer.address! == ''
                                      ? 'Agregar dirección'
                                      : _ctrl.customer.address!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: subtitulo),
                              subtitle: new Text(
                                'Dirección',
                                style: body1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInLeft(
                      child: InkWell(
                        onTap: () => _ctrl.getImage(),
                        child: new Container(
                            width: Get.width,
                            height: 200,
                            decoration: BoxDecoration(
                                color: color100,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Center(
                              child: _ctrl.isUpdate &&
                                      _ctrl.image.path == '' &&
                                      _ctrl.customer.image != null
                                  ? FutureBuilder<Uint8List?>(
                                      future: MyStorage().getFilePreview(
                                        fileId: _ctrl.customer.image!,
                                      ), //works for both public file and private file, for private files you need to be logged in
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: MemoryImage(
                                                          snapshot.data!,
                                                        ),
                                                        fit: BoxFit.cover)),
                                              )
                                            : SpinKitPulse(
                                                color: color500,
                                                size: 50.0,
                                              );
                                      },
                                    )
                                  : _ctrl.image.path == ''
                                      ? Icon(
                                          LineIcons.plusCircle,
                                          size: 45,
                                          color: Colors.white70,
                                        )
                                      : Image.file(_ctrl.image),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Button(
                        function: () {
                          if (!_formKey.currentState!.validate()) {
                            return _ctrl.btnController.reset();
                          }
                          if (_ctrl.customer.address == "") {
                            _ctrl.btnController.reset();
                            return MyAlert.showMyDialog(
                                title: 'Datos vacíos',
                                message:
                                    'la dirección es necesaria para guardar tus datos',
                                color: Colors.red);
                          }
                          if (_ctrl.isUpdate) {
                            return _ctrl.updateMyData();
                          }
                          return _ctrl.saveData();
                        },
                        btnController: _ctrl.btnController,
                        name: 'Guardar'),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )),
            ));
      },
    );
  }
}
