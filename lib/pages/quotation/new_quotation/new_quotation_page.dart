import 'package:animate_do/animate_do.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/headerPaint.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/styles/colors.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
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
    return GetBuilder<NewQuotationCtrl>(
        init: NewQuotationCtrl(),
        builder: (_ctrl) {
          return Scaffold(
            body: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Header(
                        height: 260,
                        widgetToShow: Padding(
                          padding: EdgeInsets.only(top: 25, bottom: 100),
                          child: FadeInDown(
                            child: new Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Icon(LineIcons.swatchbook,
                                    color: Colors.white, size: 49),
                                SizedBox(
                                  height: 25,
                                ),
                                new Text(
                                  'Crear cotización',
                                  style: subtituloblanco,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Obx(() => viewToShow(ctrl: _ctrl)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Obx(() => buttonNext(_ctrl)),
          );
        });
  }

  Widget viewToShow({required NewQuotationCtrl ctrl}) {
    switch (ctrl.activeStep.value) {
      case 0:
        return titleDescription(ctrl: ctrl);
      case 1:
        return _productWidget(ctrl: ctrl);
      case 2:
        return imgDataProducts(ctrl: ctrl);
      case 3:
        return clientDateExpired(ctrl: ctrl);
      case 4:
        return generate(ctrl: ctrl);
      default:
        return Text("Error inesperado");
    }
  }

  Widget titleDescription({required NewQuotationCtrl ctrl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InputText(
          key: UniqueKey(),
          name: 'Título',
          validator: Validators.nameValidator,
          autofillHints: [AutofillHints.name],
          textInputType: TextInputType.name,
          prefixIcon: Icon(LineIcons.heading),
          onChanged: (val) => ctrl.quotation.title = val,
        ),
        SizedBox(
          height: 20,
        ),
        InputText(
          key: UniqueKey(),
          initialValue: ctrl.quotation.description ?? '',
          name: 'Descripción',
          validator: Validators.nameValidator,
          autofillHints: [AutofillHints.name],
          textInputType: TextInputType.name,
          prefixIcon: Icon(LineIcons.comment),
          onChanged: (val) => ctrl.quotation.description = val,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget buttonNext(NewQuotationCtrl ctrl) {
    return ctrl.activeStep.value != 4
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
              btnController: ctrl.btnController,
              name: 'Siguiente',
              function: () {
                if (ctrl.activeStep.value == 1) {
                  if (ctrl.quotation.product!.products!.length == 0) {
                    MyAlert.showMyDialog(
                        title: 'Error',
                        message: 'Seleccione un producto.',
                        color: Colors.red);
                    return ctrl.btnController.reset();
                  }
                }
                if (ctrl.activeStep.value == 3) {
                  if (ctrl.quotation.customer?.name == null) {
                    MyAlert.showMyDialog(
                        title: 'Error',
                        message: 'Seleccione a un cliente.',
                        color: Colors.red);
                    return ctrl.btnController.reset();
                  }
                }
                if (!_formKey.currentState!.validate()) {
                  return ctrl.btnController.reset();
                }
                ctrl.activeStep++;
                ctrl.btnController.reset();
              },
            ),
          )
        : Padding(padding: EdgeInsets.all(ctrl.activeStep.value.toDouble()));
  }

  Widget _productWidget({required NewQuotationCtrl ctrl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInUp(
          child: InkWell(
            onTap: () => ctrl.showPickerProduct(context),
            child: Container(
              height: 70,
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  trailing: new Icon(Icons.arrow_drop_down),
                  title: new Text(
                    ctrl.productModelTemp.name == null
                        ? 'Selecionar producto'
                        : ctrl.productModelTemp.name ?? '',
                    style: subtitulo,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: new Text(
                    'Producto',
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
        ctrl.productModelTemp.name != null
            ? Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    name: 'Cantitdad (opcional)',
                    validator: Validators.numberValidator,
                    controller: ctrl.quantityController,
                    autofillHints: [AutofillHints.telephoneNumber],
                    textInputType: TextInputType.number,
                    prefixIcon: Icon(LineIcons.productHunt),
                    onChanged: (val) {
                      ctrl.priceController.text = "";
                      ctrl.productModelTemp.quantity = int.parse(val);
                      if (val != "")
                        ctrl.priceController.text =
                            (ctrl.productModelTemp.quantity! *
                                    ctrl.productModelTemp.price!)
                                .toString();
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    controller: ctrl.priceController,
                    key: UniqueKey(),
                    readOnly: true,
                    name: 'Precio',
                    validator: Validators.nameValidator,
                    textInputType: TextInputType.number,
                    prefixIcon: Icon(LineIcons.dollarSign),
                    onChanged: (val) {},
                  ),
                  SizedBox(height: 15),
                  Button(
                    btnController: ctrl.btnControllerSave,
                    name: 'Guardar',
                    function: () {
                      if (!_formKey.currentState!.validate()) {
                        return ctrl.btnControllerSave.reset();
                      }
                      ctrl.addproductinList(ctrl.productModelTemp);
                      ctrl.btnControllerSave.reset();
                    },
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(height: 15),
        DataTable(
          columnSpacing: 50,
          headingTextStyle: body1.copyWith(fontWeight: FontWeight.bold),
          dataTextStyle: body1,
          columns: [
            DataColumn(label: Text("Cantidad")),
            DataColumn(label: Text("Producto")),
            DataColumn(label: Text("Sub Total")),
          ],
          rows: List.generate(
            ctrl.quotation.product!.products!.length,
            (index) => DataRow(
              cells: [
                DataCell(
                  Text(
                    ctrl.quotation.product!.products![index].quantity
                        .toString(),
                  ),
                ),
                DataCell(
                  Container(
                    width: Get.width / 4,
                    child: Text(
                      ctrl.quotation.product!.products![index].name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    (ctrl.quotation.product!.products![index].price! *
                            ctrl.quotation.product!.products![index].quantity!
                                .toDouble())
                        .toStringAsFixed(2),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget clientDateExpired({required NewQuotationCtrl ctrl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInDown(
          child: InkWell(
            onTap: () => DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                    DateTime.now().day), onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
              setState(() =>
                  ctrl.quotation.expirationDate = date.millisecondsSinceEpoch);
            },
                currentTime: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day + 1),
                locale: LocaleType.es),
            child: Container(
              height: 70,
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  trailing: new Icon(Icons.arrow_drop_down),
                  title: new Text(
                      DateFormat.yMMMMEEEEd('es_US')
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              ctrl.quotation.expirationDate!))
                          .toString(),
                      style: subtitulo),
                  subtitle: new Text(
                    'Fecha de expiración',
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        FadeInUp(
          child: InkWell(
            onTap: () => ctrl.showPicker(context),
            child: Container(
              height: 70,
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  trailing: new Icon(Icons.arrow_drop_down),
                  title: new Text(
                    ctrl.customerSelected.name! == ''
                        ? 'Selecionar cliente'
                        : ctrl.customerSelected.name!,
                    style: subtitulo,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: new Text(
                    'Cliente',
                    style: body1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget imgDataProducts({required NewQuotationCtrl ctrl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInLeft(
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                Text(
                  "Agregar imagenes a la cotización (opcional)",
                  style: subtitulo,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () =>
                      ctrl.images.length < 1 ? getImage(ctrl: ctrl) : null,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: Get.width,
                    height: 200,
                    decoration: BoxDecoration(
                        color: color700,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: ctrl.images.length > 0
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(ctrl.images[0]!),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 60,
                                color: color100,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () =>
                      ctrl.images.length < 2 ? getImage(ctrl: ctrl) : null,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: Get.width,
                    height: 200,
                    decoration: BoxDecoration(
                        color: color700,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: ctrl.images.length > 1
                          ? Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(ctrl.images[1]!),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 60,
                                color: color100,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  getImage({required NewQuotationCtrl ctrl}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => ctrl.getImage(source: ImageSource.camera),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(LineIcons.camera,
                        size: 50, color: Colors.purple[700]),
                    new Text(
                      'Cámara',
                      style: body1,
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () => ctrl.getImage(source: ImageSource.gallery),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(LineIcons.image,
                        size: 50, color: Colors.amber[700]),
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
  }

  Widget generate({required NewQuotationCtrl ctrl}) {
    return new Column(
      children: [
        new Text('Ya todo está listo', style: subtitulo),
        SizedBox(height: 20),
        Button(
            function: () async {
              if (!_formKey.currentState!.validate()) {
                return ctrl.btnController.reset();
              }
              if (ctrl.customerSelected.id == "" ||
                  ctrl.customerSelected.id == null) {
                ctrl.btnController.reset();
                return MyAlert.showMyDialog(
                  title: 'Datos vacíos',
                  message:
                      'Selecciona los datos requeridos para guardar tus datos',
                  color: Colors.red,
                );
              }
              if ((await ctrl.validatepackages())) return ctrl.saveData();
              ctrl.btnController.error();
              return MyAlert.showMyDialog(
                title: 'Error',
                message: 'No cuenta con cotizaciones Disponibles',
                color: Colors.red,
              );
            },
            btnController: ctrl.btnController,
            name: 'Generar'),
        SizedBox(
          height: 12,
        ),
        TextButton(
            child: Text(
              "Cancelar",
              style: body1,
            ),
            onPressed: () => Get.back()),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
