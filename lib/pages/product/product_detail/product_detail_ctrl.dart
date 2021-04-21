import 'package:cotizapack/model/product.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductDetailCtrl extends GetxController{
  late final ProductModel product;

  @override
  void onInit() {
    product = Get.arguments;
    super.onInit();
  }
}