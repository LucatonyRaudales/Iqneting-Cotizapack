import 'package:cotizapack/pages/shop_market/shop_ctrl.dart';
import 'package:get/get.dart';

class ShopQuotationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopQuotationsCtrl>(() => ShopQuotationsCtrl());
  }
}
