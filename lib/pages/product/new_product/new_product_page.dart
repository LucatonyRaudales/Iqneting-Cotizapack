import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/repository/storage.dart';
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
      builder: (_ctrl) {
        return Scaffold(
          appBar: new AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back(result: false);
                },
              ),
              backgroundColor: color500,
              centerTitle: true,
              title: new Text('Agregar producto / servicio',
                  style: subtituloblanco)),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  children: [
                    InputText(
                      name: 'Nombre',
                      initialValue: _ctrl.product.name,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.pen),
                      onChanged: (val) => _ctrl.product.name = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'descripción',
                      initialValue: _ctrl.product.description,
                      minLines: 4,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.comment),
                      onChanged: (val) => _ctrl.product.description = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Precio',
                      initialValue: _ctrl.product.price.toString(),
                      textInputType: TextInputType.number,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.moneyBill),
                      onChanged: (val) =>
                          _ctrl.product.price = double.parse(val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      child: Container(
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: GetBuilder<NewProductCtrl>(
                            id: 'radio',
                            builder: (_) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Radio<SingingCharacter>(
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                color500),
                                        focusColor: color500,
                                        value: SingingCharacter.producto,
                                        groupValue: _.character,
                                        onChanged: (SingingCharacter? value) {
                                          _.selecttype(value);
                                        },
                                      ),
                                      Text('Producto')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<SingingCharacter>(
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                color500),
                                        focusColor: color500,
                                        value: SingingCharacter.servicio,
                                        groupValue: _.character,
                                        onChanged: (SingingCharacter? value) {
                                          _.selecttype(value);
                                        },
                                      ),
                                      Text('Servicio')
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () => _ctrl.showPicker(context),
                        child: Container(
                          height: 70,
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: ListTile(
                              trailing: new Icon(Icons.arrow_drop_down),
                              title: new Text(_ctrl.product.category!.name!,
                                  style: subtitulo),
                              subtitle: new Text('Categoría', style: body1),
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
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () => _ctrl.getImage(
                                          source: ImageSource.camera),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new Icon(LineIcons.camera,
                                              size: 50,
                                              color: Colors.purple[700]),
                                          new Text(
                                            'Cámara',
                                            style: body1,
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _ctrl.getImage(
                                          source: ImageSource.gallery),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new Icon(LineIcons.image,
                                              size: 50,
                                              color: Colors.amber[700]),
                                          new Text(
                                            'Galería',
                                            style: body1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
                                    _ctrl.product.image!.isNotEmpty
                                ? FutureBuilder<Uint8List?>(
                                    future: MyStorage().getFilePreview(
                                      fileId: _ctrl.product.image![0],
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
                                                    fit: BoxFit.cover),
                                              ),
                                            )
                                          : CircularProgressIndicator();
                                    },
                                  )
                                : _ctrl.image.path == ''
                                    ? Icon(
                                        LineIcons.plusCircle,
                                        size: 45,
                                        color: Colors.white70,
                                      )
                                    : Image.file(_ctrl.image),
                          ),
                        ),
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
                          if (_ctrl.product.category!.id == "") {
                            _ctrl.btnController.reset();
                            return MyAlert.showMyDialog(
                                title: 'Datos vacíos',
                                message:
                                    'la categoría es necesaria para guardar tus datos',
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
              ),
            ),
          ),
        );
      },
    );
  }
}
