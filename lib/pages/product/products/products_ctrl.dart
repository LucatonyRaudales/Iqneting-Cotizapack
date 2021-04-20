import 'package:cotizapack/repository/products.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductsCtrl extends GetxController{
  ProductRepository _productRepository = ProductRepository();
  @override
  void onInit() {
    print('products page');
    super.onInit();
  }

  void getProducts()async{
    try{
      _productRepository.getProducts()
      .then((value){
        switch(value!.statusCode){
          case 201:
          break;
          default:
          break;
        }
      });
    }catch(e){
      print('Error get products: $e');
    }
  }
}