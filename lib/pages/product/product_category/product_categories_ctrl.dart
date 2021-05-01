import 'dart:async';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/common/button.dart';
import 'package:cotizapack/common/dialog.dart';
import 'package:cotizapack/common/textfields.dart';
import 'package:cotizapack/common/validators.dart';
import 'package:cotizapack/model/product_category.dart';
import 'package:cotizapack/repository/product_categories.dart';
import 'package:cotizapack/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProductCategoriesCtrl extends GetxController{
  RoundedLoadingButtonController btnController = new RoundedLoadingButtonController();
  ListProductCategory productCategoryList = ListProductCategory();
  ProductCategoryRepository _productCategoryRepository = ProductCategoryRepository();
  ProductCategory productCategory = ProductCategory();
  bool haveCategory = true;
  bool isUpdate = false;

  @override
  void onInit() {
    getProductCategories();
    super.onInit();
  }

  Future getProductCategories()async{
    isUpdate = false;
    _productCategoryRepository.getCategories()
      .then((value){
        if(value.listProductCategory!.isEmpty){
          haveCategory = false;
        }
        productCategoryList = value;
        update();
      });
  }

  void showDialog(context){
  final _formKey = GlobalKey<FormState>();
    MyDialog().show(
    context:context,
    title: 'Agregar categoría',
    content: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InputText(
                      name: 'Nombre',
                      initialValue: productCategory.name,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.pen),
                      onChanged: (val)=> productCategory.name = val,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(
                      name: 'Descripción',
                      initialValue: productCategory.description,
                      minLines: 3,
                      textInputType: TextInputType.name,
                      validator: Validators.nameValidator,
                      prefixIcon: Icon(LineIcons.comment),
                      onChanged: (val)=> productCategory.description = val,
                    ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                      btnController: btnController,
                      name:"Guardar",
                      function: () {
                        if (!_formKey.currentState!.validate()) {
                              return btnController.reset();
                            }
                            isUpdate ?  updateCategory() : saveCategory( );
                        /*if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }*/
                      },
                    ),
                  ),
                  SizedBox(height: 5,),
                  TextButton(
                    child: Text("Cancelar", style: body1,),
                    onPressed:()=> Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveCategory()async{
    _productCategoryRepository.saveDocument(category: productCategory)
      .then((value){
        if(value!.statusCode == 201){
          getProductCategories();
          productCategory.name = '';
          productCategory.description = '';
          this.btnController.success();
          MyAlert.showMyDialog(title: 'Almacenado exitosamente', message: 'la categoría ${productCategory.name} fué almacenado exitósamente', color: Colors.green);
          return Timer(Duration(seconds: 3), ()=> Get.back());
        }else{
          this.btnController.error();
          MyAlert.showMyDialog(title: 'Error al guardar la categorá', message: 'hubo un error inesperado, por favor intenta de nuevo', color: Colors.red);
          return Timer(Duration(seconds:2), ()=> this.btnController.reset());
        }
      });
  }

  void updateCategory()async{
    _productCategoryRepository.updateCategory(category: productCategory)
      .then((value){
        if(value){
          getProductCategories();
          this.btnController.success();
          MyAlert.showMyDialog(title: 'Actualizado exitosamente', message: 'la categoría ${productCategory.name} fué actualizado exitósamente', color: Colors.green);
          return Timer(Duration(seconds: 3), ()=> Get.back());
        }else{
          this.btnController.error();
          MyAlert.showMyDialog(title: 'Error al guardar la categorá', message: 'hubo un error inesperado, por favor intenta de nuevo', color: Colors.red);
          return Timer(Duration(seconds:2), ()=> this.btnController.reset());
        }
      });
  }
}