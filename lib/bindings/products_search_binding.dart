import 'package:cotizapack/pages/product/products/products_ctrl.dart';
import 'package:cotizapack/pages/product/productssearch/products_search_crtl.dart';
import 'package:get/get.dart';

class ProductsSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsSearchController>(() => ProductsSearchController());
    Get.lazyPut<ProductsCtrl>(() => ProductsCtrl());
  }
}
