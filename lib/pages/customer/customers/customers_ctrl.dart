import 'package:appwrite/appwrite.dart';
import 'package:cotizapack/common/alert.dart';
import 'package:cotizapack/model/customers.dart';
import 'package:cotizapack/repository/customer.dart';
import 'package:cotizapack/settings/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CustomersCtrl extends GetxController{
  CustomerRepository _customerRepository = CustomerRepository();
  CustomerList customerList = CustomerList();
  bool haveProducts = true;
  late Storage storage;

  @override
  void onInit() {
    print('products page');
    getCustomers();
    super.onInit();
  }

  Future getCustomers()async{
    storage = Storage(AppwriteSettings.initAppwrite());
    this.haveProducts = true;
    update();
    try{
      _customerRepository.getMyCustomers()
      .then((value){
        print('si');
        print(value.customers!.length);
        if(value.customers!.isEmpty){
          this.haveProducts = false;
          return update();
        }
        if(value.customers!.isNotEmpty){
          this.customerList = value;
          return update();
        }
      });
    }catch(e){
      print('Error get products: $e');
    }
  }

    void deleteCustomer({required String customerID})async{
    _customerRepository.disableCustomer(customerID: customerID)
    .then((value){
      if(value){
      MyAlert.showMyDialog(title: 'Producto eliminado', message: 'el cliente fué eliminado satisfactoriamente', color: Colors.green);
      return getCustomers();
      }else{
        return MyAlert.showMyDialog(title: 'Error', message: 'ha ocurrido un error inesperado, por favor intenta de nuevo', color: Colors.red);
      }
    });
  }
}